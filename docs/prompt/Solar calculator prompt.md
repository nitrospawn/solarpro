# Solar Calculator Screen Prompt

Create a Flutter screen called `SolarCalculationScreen` with an `AppDrawer`. It should contain a form to input:
- Panel Rating (Pmax)
- Panel Vmp (V)
- System DC Volts (V)
- Total Batteries
- Single Battery Cap (Ah)
- A toggle for "Include Active Daytime Load" that reveals a field for "Actual Load Current (Amps DC)".

Use strict numeric-only input formatters for all number fields. When "Calculate Array" is pressed, apply the following logic:
1. Assume 12V batteries to calculate series/parallel battery strings and total Bank Ah.
2. Baseline charging current = 10% of Bank Ah.
3. Target charging voltage = System Voltage * 1.2. Total target current = baseline + (active load if toggled).
4. Calculate panels needed based on target voltage and current, rounding up to form a balanced series/parallel array.
5. Calculate MPPT minimum rating (target current) and recommended rating (target current * 1.25, rounded up to standard market sizes like 20A, 30A, 40A, 60A, etc.).

Display the results in a card showing the system goal, target current, exact/rounded panels needed, recommended array wiring (e.g., 2S2P), MPPT ratings, and a clear mechanical engineering explanation of the wiring choice.