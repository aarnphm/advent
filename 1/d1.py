import re, os, contextlib

PATH=os.path.dirname(os.path.abspath(__file__))
P=print

@contextlib.contextmanager
def read():
  with open(os.path.join(PATH, 'data.txt'), 'r') as f: yield f.readlines()

def one() -> int:
  rv = 0
  with read() as lines:
    first, last = "",""
    for line in lines:
      for c in line:
        if c.isdigit(): first = c; break
      for c in reversed(line):
        if c.isdigit(): last = c; break
      rv+=int(first+last)
  return rv

mm = {'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'}
full = {**mm, **{'1': '1', '2': '2', '3': '3', '4': '4', '5': '5', '6':'6', '7': '7', '8': '8', '9': '9'}}

def two():
  def get(line: str) -> list[int]:
    digits = []
    idx = 0
    while idx < len(line):
      for digi in full:
        if line[idx:idx+len(digi)]==digi: digits.append(full[digi]); break
      idx += 1  # edge: "6oneighthlf" => [6, 1, 8]...
    return digits
  with read() as lines:
    rv = 0
    for line in lines: digits = get(line); rv += int(digits[0]+digits[-1])
    return rv

if __name__ == "__main__": P('one:', one()); P('two:', two())
