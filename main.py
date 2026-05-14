# This sample demonstrates how common errors can be detected statically by pyright.

def add(x: float, y: float):
    return x + y

# Passing a str instance as the second argument results in a runtime exception.
add(1, "")
