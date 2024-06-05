# Automatic code generator with Prolog
The project consists on a GUI that lets a user generate code in the C++ or Python syntaxis from simple instructions.

## Technologies used 
The GUI was built using tkinter, a Python library.
Logic was made using Prolog, a file for each programming language.
Connection between logic and GUI was made with Python's subprocess.

## How to use
### To use:
- Run the main.py file.
- Select a language from the dropdown list.
- Enter a valid instruction from the following.
- Click the "generate code" button.

### Valid instructions:
- assign: assign(variable, value)
    
- assign arithmetic: assign(variable(operation(value1, value2))
  - valid operations:
    - add: addition
    - sub: subtraction
    - mul: multiplication
    - div: division
    - lt: less than
    - gt: grater than
      
- if: if(condition(variable, value), [condition true case], [condition false case])

- while: while(condition(variable, value), [logic inside the while])

- loop: loop(variable, smaller value, greater value, [logic inside the for])

- function: function(name, [input], [logic inside the function])

- various of this instructions nested in a single line are valid too

## Contents
- main.py file with the GUI
- prolog_to_cpp.pl file with the prolog logic for the translation to C++.
- prolog_to_python.pl file with the prolog logic for the translation to Python.

## Authors
- Marcela de la Rosa
- Diego Espejo
- Pablo Heredia
- Julieta Arteaga
- Adela Solorio
