import json
import z3
import os

def generate_level():
    # Example Z3 Solver for a 2-segment light path
    solver = z3.Solver()
    
    # Grid constraints (0 to 800 for X, 0 to 600 for Y)
    mirror_x = z3.Int('mirror_x')
    mirror_y = z3.Int('mirror_y')
    
    # Emitter position
    emit_x = 50
    emit_y = 300
    
    # Target position
    target_x = 750
    target_y = 500
    
    # Constraints: 
    # 1. Mirror must be strictly inside the playable area
    solver.add(mirror_x > 100, mirror_x < 800)
    solver.add(mirror_y > 100, mirror_y < 600)
    
    # 2. Path 1: Emitter to Mirror (Horizontal beam moving right)
    # This means mirror_y MUST equal emit_y
    solver.add(mirror_y == emit_y)
    
    # 3. Path 2: Mirror to Target (Vertical beam moving down)
    # This means mirror_x MUST equal target_x
    solver.add(mirror_x == target_x)
    
    if solver.check() == z3.sat:
        model = solver.model()
        m_x = model[mirror_x].as_long()
        m_y = model[mirror_y].as_long()
        
        # Calculate angle (reflection from right (1,0) to down (0,1) -> mirror angle is 45 degrees / pi/4)
        
        level_data = {
          "schema_version": "1.0.0",
          "level_id": 1,
          "circuit_name": "Z3_Generated_Circuit_01",
          "energy_budget": 100.0,
          "star_criteria": {
            "three_stars_max_energy": 50.0,
            "three_stars_max_tools": 1
          },
          "emitter": {
            "position": {"x": emit_x, "y": emit_y},
            "direction": {"x": 1.0, "y": 0.0},
            "wavelength": 632.8,
            "intensity": 100.0,
            "polarization_rad": 0.0
          },
          "target": {
            "position": {"x": target_x, "y": target_y},
            "required_wavelength_min": 630.0,
            "required_wavelength_max": 635.0,
            "min_intensity": 40.0,
            "required_polarization_rad": None,
            "required_phase": None
          },
          "fixed_elements": [],
          "available_inventory": {
            "flat_mirrors": 1,
            "grin_benders": 0,
            "polarizers": 0
          }
        }
        
        # Create output directory
        os.makedirs("../../assets/levels", exist_ok=True)
        
        with open("../../assets/levels/level_01.json", "w") as f:
            json.dump(level_data, f, indent=2)
            
        print("Level 01 generated successfully using Z3 constraints!")
        print(f"Solution: Place mirror at X: {m_x}, Y: {m_y}")
    else:
        print("Z3 failed to find a valid level layout.")

if __name__ == '__main__':
    generate_level()
