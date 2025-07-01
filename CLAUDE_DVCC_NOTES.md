# DVCC Max Charge Current Configuration Summary

## What was done:
1. Renamed original configuration.yaml to configuration_20250701.yaml as backup
2. Created new configuration.yaml with merged content including:
   - New input_number.dvcc_max_charge_current (min: 0, max: 50, step: 1)
   - All original Modbus configuration (hub: victron, unit: 100, address: 2705)
3. Added set_dvcc_max_current script to scripts.yaml

## Key details:
- Modbus hub name: victron
- Modbus host: 192.168.1.190:502
- DVCC register: address 2705, unit/slave 100
- Safe limits: 0-50A with 1A steps

## Next steps after HA restart:
1. Check Developer Tools → States for input_number.dvcc_max_charge_current
2. Test script via Developer Tools → Services → script.set_dvcc_max_current
3. Add to dashboard if desired
