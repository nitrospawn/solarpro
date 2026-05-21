# Inverter Calculator Screen Prompt

Create a Flutter screen called `InverterCalculationScreen` with an `AppDrawer`. It should feature a form for:
- Inverter Capacity (VA) & Inverter DC Volts (V)
- Single Battery Cap (Ah) & Single Battery DC Volts (V)
- Total Batteries (integer only)
- Dropdown for Battery Type (AGM, GEL, Flooded, Lithium)
- Connected Load (Watts)

Enforce strict numeric-only input formatters. When "Calculate" is pressed:
1. Calculate battery series/parallel wiring to match the inverter voltage. Calculate total bank Ah and raw kWh.
2. Calculate usable kWh using Depth of Discharge (DoD: Lithium 80%, others 50%).
3. Calculate DC current drawn at full load and actual connected load using efficiency (Lithium 95%, Flooded 80%, AGM/GEL 85%).
4. Calculate estimated runtime in hours. Calculate recommended charge current (min 10% of Ah, max 20% or 50% for Lithium).

Display the Battery configuration, battery bank total Ah, raw/usable energy, full/actual load currents, estimated runtime, and Charging (Amps) range in a styled results card below the form.