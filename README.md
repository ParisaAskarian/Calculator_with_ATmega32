# Simple Calculator

This project implements a simple calculator capable of performing addition, subtraction, multiplication, and division.

The calculator's hardware is based on the **ATmega32 microcontroller**, and its output is displayed on a **16-column, 2-row LCD**. The calculator's algorithm is implemented in the **C programming language**.

## How It Works

Each time a key is pressed, its corresponding character is stored in a list named `exp`. When the `=` key is pressed, the program begins traversing the list and evaluating the expression.

- **Operands:** If the current character is an operand (digit), it is pushed onto a stack named `fix_operand` until all digits of the number have been read. Once the complete number is formed, it is read and pushed onto the operand stack using the `read_and_push` function.
- **Operators:** If the current character is an operator, its precedence is compared with the operator at the top of the operator stack. If the current operator has lower or equal precedence, the operator at the top of the stack is popped, two operands are popped from the operand stack, the corresponding operation is performed, and the result is pushed back onto the operand stack.

This process continues until the operator stack becomes empty or the current operator has higher precedence than the operator at the top of the stack.

After all characters in `exp` have been processed, the program checks the operator and operand stacks. If the operator stack is not empty, it enters a loop in which each iteration pops one operator and two operands, performs the corresponding operation, and pushes the result back onto the operand stack. This loop continues until the operator stack becomes empty, provided that the entered expression is valid (e.g., `2*3-5`).

## Error Handling

The program also handles invalid expressions. For example, if the user enters:

```text
**8-5//
```

the LCD displays:

```text
Invalid Expression
```

## Development Status

This project is still under development. Some minor issues are being addressed, such as an extra `0` appearing at the end of the `Invalid Expression` message. The code is also being refined to improve its optimization, readability, and overall structure.

## Contributors

- Parisa Askarian – Developer
- Ala Zahedifar – Developer
