# Load Calculator Screen Prompt

Create a Flutter screen called `LoadAnalyzerScreen` using Riverpod state management. It should be structured using a `CustomScrollView` with the following sections:

1. **Hero Summary Card:** A visually striking gradient container at the top displaying Total Daily Energy (kWh), Running Load (W), and Peak Surge Load (W) calculated dynamically from the active appliance list.
2. **Input Form:** A card to add appliances with fields for Name, Quantity, Watts, Surge (x), and Hours. Utilize strict numeric input formatters (allow decimals for watts/surge/hours, digits only for quantity). Include a "Quick Select Preset" dropdown populated with common off-grid appliances (e.g., Fridge, Pumping machine, TV) that auto-fills the form.
3. **Active Load List:** A list displaying the active appliances in memory with their respective details and a trailing delete icon to remove them.

The `AppBar` should include three actions:
- Clear all active appliances.
- Generate a PDF Proposal (which runs a background sizing engine for Inverter, Battery, and Solar, and opens a native print/share dialog).
- Save Project (which persists the appliance list to a local SQLite database, handling both creating new projects and silently updating active/loaded projects).

Include an `AppDrawer` for app-wide navigation.