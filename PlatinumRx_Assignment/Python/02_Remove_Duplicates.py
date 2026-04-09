"""
PlatinumRx Assignment | Phase 3 - Python Proficiency
File  : 02_Remove_Duplicates.py
Author: [Your Name]

Goal  : Given a string, remove all duplicate characters using a loop,
        preserving the first occurrence order.
        e.g.  "programming" → "progamin"
              "aabbcc"      → "abc"
              "hello world" → "helo wrd"
"""


def remove_duplicates(input_string: str) -> str:
    """
    Remove duplicate characters from a string using an explicit loop.
    The first occurrence of each character is kept; subsequent ones are dropped.
    Case-sensitive: 'A' and 'a' are treated as different characters.

    Parameters
    ----------
    input_string : str
        The input string to process.

    Returns
    -------
    str
        A new string with duplicate characters removed.

    Raises
    ------
    TypeError
        If the input is not a string.
    """
    if not isinstance(input_string, str):
        raise TypeError(f"Expected str, got {type(input_string).__name__}")

    result = ""                         # Accumulates unique characters

    # ── Core loop logic ─────────────────────────────────────────────
    for char in input_string:           # Iterate over every character
        if char not in result:          # Only add if not already seen
            result += char              # Append unique character
    # ────────────────────────────────────────────────────────────────

    return result


# ── Manual test-cases ────────────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [
        "programming",
        "aabbcc",
        "hello world",
        "abcabc",
        "112233",
        "PlatinumRx",
        "",
        "a",
    ]

    print("=" * 50)
    print(f"{'Input':<25} {'Output'}")
    print("=" * 50)
    for s in test_cases:
        print(f"{repr(s):<25} {repr(remove_duplicates(s))}")
    print("=" * 50)

    # Interactive mode
    print("\nEnter a string to remove duplicates (or 'q' to quit):")
    while True:
        user_input = input("String: ")
        if user_input.lower() == "q":
            break
        result = remove_duplicates(user_input)
        print(f"  → {repr(result)}")
