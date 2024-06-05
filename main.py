import tkinter as tk
from tkinter import ttk
import subprocess

class CodeGeneratorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Code Generator")

        # Create a label for language selection
        self.lang_label = ttk.Label(root, text="Select Target Language:")
        self.lang_label.pack()

        # Create a Combobox for language selection
        self.lang_combo = ttk.Combobox(root, values=["Python", "C++"])
        self.lang_combo.pack()

        # Create a text area for input
        self.input_label = ttk.Label(root, text="Enter Code:")
        self.input_label.pack()
        self.input_text = tk.Text(root, height=10, width=50)
        self.input_text.pack()

        # Create a button to generate code
        self.generate_btn = ttk.Button(root, text="Generate Code", command=self.generate_code)
        self.generate_btn.pack()

        # Create a text area for output
        self.output_label = ttk.Label(root, text="Generated Code:")
        self.output_label.pack()
        self.output_text = tk.Text(root, height=10, width=50, state="disabled")
        self.output_text.pack()

    def generate_code(self):
        try:
            # Get the selected language
            selected_lang = self.lang_combo.get()

            # Get the input code
            input_code = self.input_text.get("1.0", "end-1c")

            # Generate code based on the selected language
            if selected_lang == "Python":
                generated_code = self.translate_to_python(input_code)
            elif selected_lang == "C++":
                generated_code = self.translate_to_cpp(input_code)
            else:
                generated_code = "Invalid language selection."

            # Display the generated code
            self.output_text.config(state="normal")
            self.output_text.delete("1.0", "end")
            self.output_text.insert("1.0", generated_code)
            self.output_text.config(state="disabled")
        except Exception as e:
            # Display the error message
            error_msg = f"Error occurred: {str(e)}"
            self.output_text.config(state="normal")
            self.output_text.delete("1.0", "end")
            self.output_text.insert("1.0", error_msg)
            self.output_text.config(state="disabled")

    def translate_to_python(self, input_code):
        try:
            # Call Prolog script for Python translation
            command = ['swipl', '-s', 'prolog_to_python.pl', '-g', f"translate_input([{input_code}], Output), write(Output), halt."]
            result = subprocess.run(command, capture_output=True, text=True)
            return result.stdout.strip() if result.returncode == 0 else result.stderr.strip()
        except Exception as e:
            return f"Error in Python translation: {str(e)}"

    def translate_to_cpp(self, input_code):
        try:
            # Call Prolog script for C++ translation
            command = ['swipl', '-s', 'prolog_to_cpp.pl', '-g', f"translate_input([{input_code}], Output), write(Output), halt."]
            result = subprocess.run(command, capture_output=True, text=True)
            return result.stdout.strip() if result.returncode == 0 else result.stderr.strip()
        except Exception as e:
            return f"Error in C++ translation: {str(e)}"

if __name__ == "__main__":
    root = tk.Tk()
    app = CodeGeneratorGUI(root)
    root.mainloop()
