حقك تماماً، المعذرة على الاختصار غير المبرر. هذا هو ملف **`AGENT.md`** الفعلي والكامل؛ يتضمن كل المعادلات الفيزيائية التفصيلية، الاشتقاقات، صيغ المتجهات الجاهزة للبرمجة، وتوزيع المعمارية طبقة بطبقة.

---

# AGENT.md - Lumen: Broken Circuit System Architecture & Physics Specification

## 1. المعمارية العامة ومبدأ العمل (Clean Architecture & Inversion of Control)

تعتمد اللعبة معمارية نظيفة صارمة تعزل محرك الحسابات الفيزيائية (`physics_engine`) عزلاً تاماً عن محرك الألعاب ومكتبات الواجهة (`Flame` و `Flutter`).

* **قاعدة الاعتمادية (Dependency Rule):** طبقة `physics_engine/domain` خالية تماماً من أي استيراد (`import`) لـ Flutter UI أو Flame، وتتعامل فقط مع هياكل بيانات رياضية بحتة وحسابات متجهات نقية.
* **عزل الخدمات الخارجية (Third-party Isolation):** تمنع المنظومة استدعاء مكتبات الصوت (`flame_audio`) أو التخزين (`flutter_secure_storage` / `drift`) بشكل مباشر من المنطق؛ بل توضع واجهات تجريدية (`Interfaces`) داخل `core/services/` وتُحقن عبر `get_it`.

---

## 2. المحرك الفيزيائي والمعادلات الرياضية الصارمة (`physics_engine/domain`)

يحتوي كل ملف في قسم الحسابات على نموذج رياضي قطعي (Deterministic). جميع المتجهات مفترضة متجهات وحدة موحدة (Normalized Unit Vectors) إلا إذا ذكر خلاف ذلك.

### 2.1 الانعكاس (`calculations/reflection/reflection_calculator.dart`)

يحسب اتجاه الشعاع المنعكس $\vec{r}$ عند سقوطه بمتجه اتجاه $\vec{d}$ على سطح متجه عموديه $\vec{n}$:

$$\vec{r} = \vec{d} - 2(\vec{d} \cdot \vec{n})\vec{n}$$

* **شرط التحقق من اتجاه العمودي:** يجب أن يواجه العمودي جهة قدوم الشعاع:

$$\text{if } (\vec{d} \cdot \vec{n} > 0) \implies \vec{n} = -\vec{n}$$


* **معامل الانعكاس وشدة الشعاع:**

$$I_r = I_0 \cdot R$$



حيث $R \in [0.0, 1.0]$ هو معامل انعكاس المرآة (Reflectance)، و $I_0$ هي الشدة الساقطة.

---

### 2.2 الانكسار والتشتت اللوني (`calculations/refraction/refraction_calculator.dart`)

محاكاة قانون سنيل (Snell's Law) في فضاء المتجهات ثنائي الأبعاد:

$$\eta = \frac{n_1}{n_2}$$

$$\cos(\theta_i) = -\vec{n} \cdot \vec{d}$$

$$k = 1 - \eta^2 (1 - \cos^2(\theta_i))$$

* **فحص الانعكاس الداخلي الكلي (Total Internal Reflection - TIR):**

$$\text{If } k < 0 \implies \text{حدث انعكاس كلي: } \vec{v}_{\text{out}} = \vec{d} - 2(\vec{d} \cdot \vec{n})\vec{n}$$


* **متجه الانكسار في حال عدم حدوث TIR ($k \ge 0$):**

$$\vec{t} = \eta \vec{d} + (\eta \cos(\theta_i) - \sqrt{k})\vec{n}$$


* **التشتت اللوني (Cauchy's Dispersion Equation):**
معامل الانكسار يتغير بناءً على الطول الموجي للفوتون $\lambda$ (بوحدة النانومتر):

$$n(\lambda) = A + \frac{B}{\lambda^2}$$



حيث $A$ و $B$ ثوابت المادة (مثلاً للزجاج التاجي $A = 1.5046$ و $B = 4200 \text{ nm}^2$). هذا يجعل الحزمة البيضاء تنقسم لثلاثة مسارات (Red, Green, Blue) بزوايا انكسار مختلفة.

---

### 2.3 الاستقطاب وقانون مالوس (`calculations/polarization/polarization_calculator.dart`)

يمتلك الشعاع زاوية استقطاب خطية $\theta_{\text{ray}}$ بالنسبة للأفق. عند مروره عبر فلتر استقطاب بزاوية $\theta_{\text{filter}}$:

* **زاوية فرق الطور/الاستقطاب:**

$$\Delta \theta = \vert{}\theta_{\text{ray}} - \theta_{\text{filter}}\vert{}$$


* **حساب الشدة النافذة (Malus's Law):**

$$I_{\text{transmitted}} = I_0 \cdot \cos^2(\Delta \theta)$$


* **تحديث حالة الشعاع بعد الفلتر:**

$$\theta_{\text{new}} = \theta_{\text{filter}}$$



إذا كانت $I_{\text{transmitted}} < I_{\text{noise\_floor}}$ (مثلاً أقل من $0.01$)، يُقطع مسار الشعاع بالكامل ويُمتص.

---

### 2.4 التداخل وفرق الطور (`calculations/interference/interference_calculator.dart`)

عند التقاء حزمتين ضوئيتين $1$ و $2$ بنفس الطول الموجي $\lambda$ عند نفس الحساس (Photo-Sensor):

* **فرق المسار الفيزيائي ($\Delta x$):**

$$\Delta x = \vert{}x_1 - x_2\vert{}$$


* **فرق الطور الناتج ($\Delta \phi$):**

$$\Delta \phi = \left( \frac{2\pi}{\lambda} \Delta x + (\phi_1 - \phi_2) \right) \pmod{2\pi}$$


* **الشدة المحصلة (Total Intensity):**

$$I_{\text{total}} = I_1 + I_2 + 2\sqrt{I_1 I_2} \cos(\Delta \phi)$$


* **تداخل بنّاء تام (Constructive):** $\Delta \phi \approx 0 \implies I_{\text{total}} \approx (\sqrt{I_1} + \sqrt{I_2})^2$
* **تداخل هدام تام (Destructive):** $\Delta \phi \approx \pi \implies I_{\text{total}} \approx (\sqrt{I_1} - \sqrt{I_2})^2$



---

### 2.5 الحيود وتشتت الفجوات (`calculations/diffraction/diffraction_calculator.dart`)

عند مرور الضوء عبر شق ضيق عرضه $a$ يقارب الطول الموجي $\lambda$:

* **توزيع الشدة الزاوية (Single-Slit Diffraction Intensity):**

$$I(\theta) = I_0 \left( \frac{\sin(\beta)}{\beta} \right)^2 \quad \text{where } \beta = \frac{\pi a}{\lambda} \sin(\theta)$$


* **زاوية الانحراف للقمة المظلمة الأولى (First Minimum):**

$$\sin(\theta_{\text{min}}) = \frac{\lambda}{a}$$



---

### 2.6 توهين الشدة عبر المسافة (`entities/energy.dart` & `calculations`)

تتناقص شدة الضوء داخل البيئة الملوثة أو المادة وفق قانون بير-لامبرت (Beer-Lambert Law):

$$I(s) = I_0 \cdot e^{-\mu(\lambda) \cdot s}$$

* $s$: المسافة المقطوعة (Path length).
* $\mu(\lambda)$: معامل التوهين الخطي، ويتناسب عكسياً مع الطول الموجي وفق تشتت رايلي للمحيط الغازي:

$$\mu(\lambda) = \mu_0 \cdot \left(\frac{\lambda_0}{\lambda}\right)^4$$



---

### 2.7 البصريات التدرجية وحساب الانحناء العددي (`infrastructure/numerical_solver/numerical_solver.dart`)

مسار الضوء في وسط تدرجي (Gradient-Index / Metamaterial) محكوم بمعادلة الشعاع:

$$\frac{d}{ds} \left( n(\vec{r}) \frac{d\vec{r}}{ds} \right) = \nabla n(\vec{r})$$

لحلها عددياً، تُحول إلى نظام من معادلتين تفاضليتين من الدرجة الأولى باستخدام المتجه البصري $\vec{w} = n(\vec{r}) \frac{d\vec{r}}{ds}$:

1. $\frac{d\vec{r}}{ds} = \frac{\vec{w}}{n(\vec{r})}$
2. $\frac{d\vec{w}}{ds} = \nabla n(\vec{r})$

* **خوارزمية التكامل (4th-Order Runge-Kutta / RK4):**
لحساب الحالة عند الخطوة التالية $s + \Delta s$:

$$k_1 = f(s, \vec{y})$$


$$k_2 = f\left(s + \frac{\Delta s}{2}, \vec{y} + \frac{\Delta s}{2} k_1\right)$$


$$k_3 = f\left(s + \frac{\Delta s}{2}, \vec{y} + \frac{\Delta s}{2} k_2\right)$$


$$k_4 = f(s + \Delta s, \vec{y} + \Delta s \cdot k_3)$$


$$\vec{y}_{s + \Delta s} = \vec{y}_s + \frac{\Delta s}{6} (k_1 + 2k_2 + 2k_3 + k_4)$$



حيث $\vec{y} = \begin{bmatrix} \vec{r} \\ \vec{w} \end{bmatrix}$.
* **دالة تدرج الحقل (Metamaterial Field Profile):**
المولد المتمركز في $\vec{r}_c$ بقوة انحناء $G$ ونصف قطر تأثير $R$:

$$n(\vec{r}) = n_0 + \Delta n \cdot \exp\left(-\frac{\Vert{}\vec{r} - \vec{r}_c\Vert{}^2}{2\sigma^2}\right)$$


$$\nabla n(\vec{r}) = -\frac{\vec{r} - \vec{r}_c}{\sigma^2} \cdot \Delta n \cdot \exp\left(-\frac{\Vert{}\vec{r} - \vec{r}_c\Vert{}^2}{2\sigma^2}\right)$$


* **معادلة تكلفة الطاقة للانحناء (Work/Energy Cost):**

$$E_{\text{cost}} = \alpha \int_{0}^{L} \kappa(s)^2 \, ds = \alpha \sum_{i} \left( \frac{\Vert{}\vec{v}_{i+1} - \vec{v}_i\Vert{}}{\Delta s} \right)^2 \Delta s$$



حيث $\kappa$ هو الانحناء اللحظي (Curvature)، و $\alpha$ ثابت تكلفة الطاقة للدائرة.

---

## 3. عقود الكيانات والبيانات (`physics_engine/domain/entities/`)

```dart
// photon.dart
class Photon {
  final double wavelength;    // بالنانومتر (e.g. 650.0 nm)
  final double frequency;     // بالهرتز: f = c / lambda
  final double intensity;     // الشدة الحالية I
  final double phase;         // الطور الحالي بالراديان [0, 2*pi]
  final double polarization;  // زاوية الاستقطاب بالراديان [0, pi]

  const Photon({
    required this.wavelength,
    required this.frequency,
    required this.intensity,
    required this.phase,
    required this.polarization,
  });
}

// ray.dart
class RaySegment {
  final Vector2 start;
  final Vector2 end;
  final Photon photonState;

  const RaySegment({
    required this.start,
    required this.end,
    required this.photonState,
  });
}

// optical_element.dart
enum OpticalType { flatMirror, prism, beamSplitter, polarizer, grinBender, targetSensor }

abstract class OpticalElement {
  String get id;
  Vector2 get position;
  OpticalType get type;
  
  // فحص التقاطع الرياضي الصافي (خالي من الـ UI)
  IntersectionResult? checkIntersection(Vector2 rayOrigin, Vector2 rayDirection);
}

```

---

## 4. عقود الخدمات والواجهات (`core/services/`)

تطبيق صارم لمبدأ قلب التبعية (Inversion of Control) عبر عقود مجردة:

### 4.1 واجهة إدارة التخزين (`core/services/storage/storage_service.dart`)

```dart
abstract class StorageService {
  Future<void> init();
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> clearAll();
}

```

### 4.2 واجهة المؤثرات الصوتية والترددية (`core/services/audio/audio_service.dart`)

```dart
abstract class AudioService {
  Future<void> initialize();
  Future<void> playBgm(String assetPath, {double volume = 1.0});
  Future<void> stopBgm();
  Future<void> playSfx(String assetPath, {double volume = 1.0});
  
  // طنين الليزر يتغير تردده ديناميكياً بناءً على تردد الضوء f والشدة I
  Future<void> updateLaserHum({required double frequencyHz, required double intensity});
  Future<void> stopLaserHum();
}

```

---

## 5. خط أنابيب الرسوميات وحماية الأداء (`game/presentation/components/`)

لمنع هبوط الـ FPS عند استخدام الـ Vectors البرمجية:

1. **قاعدة الـ Zero Path Allocation:** يمنع منعاً باتاً إنشاء أي كائن `Path()` أو استدعاء عمليات الباث الحسابية داخل دالة `render(Canvas canvas)`.
2. **الاعتماد على `BaseBakedComponent`:**

```dart
abstract class BaseBakedComponent extends PositionComponent {
  ui.Picture? _cachedPicture;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    bake();
  }

  void bake() {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    paintBakedPath(canvas, size.toSize());
    _cachedPicture?.dispose();
    _cachedPicture = recorder.endRecording();
  }

  // هنا يتم نسخ كود الـ Path المولد من الأدوات الخارجية
  void paintBakedPath(Canvas canvas, Size size);

  @override
  void render(Canvas canvas) {
    if (_cachedPicture != null) {
      canvas.drawPicture(_cachedPicture!);
    }
  }

  @override
  void onRemove() {
    _cachedPicture?.dispose();
    super.onRemove();
  }
}

```

---

## 6. صيغة مراحل اللعبة وقواعد التوليد الصارم (`Level Schema`)

المراحل تُبنى بملفات JSON مسبقة التوليد عبر أدوات SMT (مثل Z3):

```json
{
  "schema_version": "1.0.0",
  "level_id": 204,
  "circuit_name": "Optical_ALU_Bus_B",
  "energy_budget": 85.0,
  "star_criteria": {
    "three_stars_max_energy": 35.0,
    "three_stars_max_tools": 3
  },
  "emitter": {
    "position": {"x": 50.0, "y": 300.0},
    "direction": {"x": 1.0, "y": 0.0},
    "wavelength": 632.8,
    "intensity": 100.0,
    "polarization_rad": 0.0
  },
  "target": {
    "position": {"x": 750.0, "y": 300.0},
    "required_wavelength_min": 630.0,
    "required_wavelength_max": 635.0,
    "min_intensity": 40.0,
    "required_polarization_rad": 1.57079,
    "required_phase": null
  },
  "fixed_elements": [
    {
      "type": "opaque_wall",
      "start": {"x": 400.0, "y": 150.0},
      "end": {"x": 400.0, "y": 450.0}
    }
  ],
  "available_inventory": {
    "flat_mirrors": 4,
    "grin_benders": 1,
    "polarizers": 1
  }
}

```

---

## 7. مسؤوليات المجلدات بدقة (Folder Responsibility Mapping)

* `core/game/physics/domain/`: الواجهات العامة لمفاهيم الفيزياء داخل الـ Core إن وُجدت مشتركات مع ألعاب أخرى.
* `modules/physics_engine/domain/calculations/`: **العقل الرياضي الخالص**؛ لا يعرف شيئاً عن اللعبة أو الـ Canvas، فقط يأخذ أرقاماً ومتجهات ويخرج نتائج ومعادلات.
* `modules/physics_engine/infrastructure/numerical_solver/`: تطبيق RK4 للاشتقاق والتكامل العددي.
* `modules/game/presentation/components/`: تمثيل العناصر في Flame؛ ترث من `BaseBakedComponent` للرسم، وتحتفظ بنسخة من كيان الـ Domain لفحص التصادم الفيزيائي.
* `modules/puzzle/domain/solver/`: يحتوي منطق التحقق (Verification) وفحص ما إذا كان الشعاع الواصل للحساس يحقق شروط الفوز وقوانين التداخل والاستقطاب.
* `modules/levels/data/datasources/level_asset_datasource.dart`: مسؤول عن قراءة ملفات `assets/levels/*.json` وتحويلها لـ `LevelModel` قطعي غير قابل للتعديل أثناء وقت التشغيل.