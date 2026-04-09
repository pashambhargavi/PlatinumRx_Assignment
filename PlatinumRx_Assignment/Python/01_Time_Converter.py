"""
PlatinumRx Assignment | Phase 3 - Python Proficiency
File  : 01_Time_Converter.py
Author: [Your Name]

Goal  : Convert a given number of minutes into a human-readable string.
        e.g.  130 → "2 hrs 10 minutes"
              110 → "1 hr 50 minutes"
               45 → "45 minutes"
                0 → "0 minutes"
"""


def convert_minutes(total_minutes: int) -> str:
    """
    Convert total minutes into human-readable hours and minutes.

    Parameters
    ----------
    total_minutes : int
        A non-negative integer representing the total number of minutes.

    Returns
    -------
    str
        A human-readable string such as "2 hrs 10 minutes".

    Raises
    ------
    ValueError
        If total_minutes is negative.
    """
    if not isinstance(total_minutes, int):
        raise TypeError(f"Expected int, got {type(total_minutes).__name__}")
    if total_minutes < 0:
        raise ValueError("Minutes cannot be negative.")

    # ── Core logic ──────────────────────────────────────────────────
    hours           = total_minutes // 60   # Integer division → whole hours
    remaining_mins  = total_minutes  % 60   # Modulo       → leftover minutes
    # ────────────────────────────────────────────────────────────────

    # Build a readable string with proper singular/plural forms
    if hours == 0:
        return f"{remaining_mins} minutes"
    elif remaining_mins == 0:
        hr_label = "hr" if hours == 1 else "hrs"
        return f"{hours} {hr_label}"
    else:
        hr_label = "hr" if hours == 1 else "hrs"
        return f"{hours} {hr_label} {remaining_mins} minutes"


# ── Manual test-cases ────────────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [130, 110, 60, 45, 0, 1, 61, 1440]

    print("=" * 40)
    print(f"{'Input (min)':<15} {'Output'}")
    print("=" * 40)
    for mins in test_cases:
        print(f"{mins:<15} {convert_minutes(mins)}")
    print("=" * 40)

    # Interactive mode
    print("\nEnter minutes to convert (or 'q' to quit):")
    while True:
        user_input = input("Minutes: ").strip()
        if user_input.lower() == "q":
            break
        try:
            result = convert_minutes(int(user_input))
            print(f"  → {result}")
        except (ValueError, TypeError) as err:
            print(f"  ✗ Error: {err}")
