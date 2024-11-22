+	Double-click the file named 'code' to run the editor.
+	Create a new file and save it in the 'Assembly Programming Tools' folder (.asm extension will be appended automatically).
+	The filename should not be more than eight characters long and should not contain any spaces.
+	Write your assembly program in the file.
+	Press Alt+R (to assemble and run) or Alt+D (to assemble and debug) your code.
+	If there are errors in your code, they will be displayed in the console at the bottom of the screen alongside line numbers.
+	Otherwise, a .com file and a .lst file will be created for your .asm file.
+	Then DOSBox will be opened and either the program will be run (if Alt+R), or the program will be opened in AFD (if Alt+D).
+	Alternatively, press Alt+A to assemble only, or Alt+E to run DOSBox only.
+	Here is a sample assembly program for you. Copy-paste it to test out the functionality:
+	It should display the letter 'B' at the start of the third line in DOSBox.
+	Then modify it and try to assemble it again to see the error displayed at the bottom console.

[org 0x0100]

	start:
	
		MOV		AX, 0xB800
		MOV		ES, AX
		
		MOV		WORD [ES:0320], 0x0742
	
	MOV		AX, 0x4C00
	INT		0x21
	
	
./afd_debug.sh 
