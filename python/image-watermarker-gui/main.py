import PIL.Image, PIL.ImageFont, PIL.ImageDraw
from tkinter import *
from tkinter import filedialog, messagebox
from PIL import ImageTk  # Import for displaying images in Tkinter

class WatermarkApp:
    def __init__(self):
        self.root = Tk()
        self.root.title("Window Marker App")
        
        window_width = 300
        window_height = 400
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()

        center_x = int(screen_width / 2 - window_width / 2)
        center_y = int(screen_height / 2 - window_height / 2)

        self.root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')
        self.page_stack = []
        self.home_page()
        self.root.grid_rowconfigure(0, weight=1) 
        self.root.grid_columnconfigure(0, weight=1)
        self.root.mainloop()

    def home_page(self):
        self.mainframe = Frame(self.root)
        self.mainframe.grid(column=0, row=0, padx=10, pady=10, sticky="nsew")
        self.mainframe.grid_rowconfigure(1, weight=0)
        self.mainframe.grid_columnconfigure(0, weight=1)

        self.label_homepage = Label(self.mainframe, text="Add Watermark", font=("Arial", 14))
        self.label_homepage.grid(row=1, column=0, sticky="n")
        
        self.button = Button(self.mainframe, text="Upload your image file", command=self.upload_image)
        self.button.grid(row=3, column=0)

        self.image_label = Label(self.mainframe)  # Label to display image
        self.image_label.grid(row=4, column=0, pady=10)

        self.page_stack.append(self.home_page)
        self.continue_btn_home_page = Button(self.mainframe,text="Continue",command=lambda: self.show_frame(self.watermark_page))
        self.continue_btn_home_page.grid(row=7,column=0,pady=10)

    def show_frame(self,page_func):
        self.page_stack.append(page_func)
        self.clear_frame()
        page_func()

    def go_back(self):
        if len(self.page_stack) > 1:
            self.clear_frame()
            self.page_stack.pop()  # Remove current page
            self.page_stack[-1]()  # Show the previous page
        else:
            messagebox.showwarning("Navigation Error", "No more pages to go back to.")
      
    def upload_image(self):
        self.filepath = filedialog.askopenfilename(
            title="Select an Image",
            filetypes=[("PNG", "*.png"), ("JPG", "*.jpg"), ("JPEG", "*.jpeg"), ("ICO", "*.ico")]
        )
        if not self.filepath:
            messagebox.showwarning("File not selected", "Please upload an image file!")
        else:
            self.show_image()
    
    def show_image(self):
        self.image = PIL.Image.open(self.filepath)
        self.image.thumbnail((200, 200))  # Resize for display
        self.photo = ImageTk.PhotoImage(self.image)
        self.image_label.config(image=self.photo)
        self.image_label.image = self.photo  # Keep a reference to avoid garbage collection

    def watermark_page(self):
        self.label_watermark = Label(self.mainframe, text="Insert the text you want to watermark", font=("Arial", 14))
        self.label_watermark.grid(row=1, column=0, sticky='n', pady=(0, 10))
    
        self.text_field = Entry(self.mainframe, font=('Arial', 14))
        self.text_field.grid(row=2, column=0, sticky='n', padx=10, pady=10)

        # Add a dropdown for font selection
        self.label_font = Label(self.mainframe, text="Select Font:", font=("Arial", 12))
        self.label_font.grid(row=3, column=0, sticky='n', pady=(10, 0))

        self.font_var = StringVar(self.mainframe)
        self.font_var.set("Arial")  # Default font
        self.available_fonts = ["Arial", "Roboto", "Times New Roman", "Courier New"]  # Add other fonts as needed
        self.font_menu = OptionMenu(self.mainframe, self.font_var, *self.available_fonts)
        self.font_menu.grid(row=4, column=0, pady=10)
        
        # Add an input field for font size selection
        self.label_font_size = Label(self.mainframe, text="Select Font Size:", font=("Arial", 12))
        self.label_font_size.grid(row=5, column=0, sticky='n', pady=(10, 0))

        self.font_size_var = StringVar(self.mainframe, value="40")  # Set default size
        self.font_size_field = Entry(self.mainframe, textvariable=self.font_size_var, font=("Arial", 12))
        self.font_size_field.grid(row=6, column=0, sticky='n', pady=(10, 0))

        
        self.continue_button = Button(self.mainframe, text="Continue", command=self.save_text_and_continue)
        self.continue_button.grid(row=9, column=0, pady=10, sticky='n')

        self.back_button = Button(self.mainframe, text="Back", command=self.go_back)
        self.back_button.grid(row=10, column=0, pady=10, sticky="n")
        
    def save_text_and_continue(self):
        # Get the watermark text
        self.watermark_text = self.text_field.get()
        
        # Validate input
        error_messages = []
        
        # Check if watermark text is empty
        if not self.watermark_text:
            error_messages.append("Watermark text cannot be empty.")
        
        # Check if font size is numeric
        if not self.font_size_field.get().isdigit():
            error_messages.append("Font size must be numeric.")
        else:
            self.font_size = int(self.font_size_field.get())
        
        # Check if there are any error messages
        if error_messages:
            messagebox.showwarning("Input Error", "\n".join(error_messages))
            return  # Return early if there are errors

        # If all validations passed, proceed to get the font and navigate to the next page
        self.get_font = self.get_font_path(self.font_var.get())
        self.show_frame(self.location_page)

    def location_page(self):
        
        self.label_coordinate_x = Label(self.mainframe, text="Coordinate X:")
        self.label_coordinate_x.grid(row=1, column=0, sticky='n', pady=(0, 10))

        self.coordinate_x_field = Entry(self.mainframe, font=('Arial', 14))
        self.coordinate_x_field.grid(row=1, column=1, sticky='n', pady=(0, 10))

        self.label_coordinate_y = Label(self.mainframe, text="Coordinate Y:")
        self.label_coordinate_y.grid(row=2, column=0, sticky='n', pady=(0, 10))

        self.coordinate_y_field = Entry(self.mainframe, font=('Arial', 14))
        self.coordinate_y_field.grid(row=2, column=1, sticky='n', pady=(0, 10))

        self.apply_button = Button(self.mainframe, text="Apply Watermark", command=self.apply_watermark)
        self.apply_button.grid(row=3, column=0, columnspan=2, pady=10)

        self.back_button = Button(self.mainframe, text="Back", command=self.go_back)
        self.back_button.grid(row=4, column=0, pady=10, columnspan=2 , sticky="n")

    def get_font_path(self,font_name):
        """Return the path to the font file based on the selected font."""
        font_paths = {
            "Arial" : "./Arial.ttf",
            "Roboto": "./Roboto-Regular.ttf",
            "Times New Roman": "./TimesNewRoman.ttf",
            "Courier New": "./CourierNew.ttf"
        }
        return font_paths.get(font_name,"./Arial.ttf")
    def apply_watermark(self):
        try:
            x = int(self.coordinate_x_field.get())
            y = int(self.coordinate_y_field.get())
            text = self.watermark_text
            
            if not text:
                messagebox.showwarning("Input Error", "Please enter the text for the watermark.")
                return

            im = PIL.Image.open(self.filepath)
            watermark_im = im.copy()
            
            draw = PIL.ImageDraw.Draw(watermark_im)
            try:
                fnt = PIL.ImageFont.truetype(self.get_font,self.font_size)
            except:
                messagebox.showerror("Error",f"Font {self.get_font} not found!")  
            draw.text((x, y), text, fill=(0, 0, 0), font=fnt)
            watermark_im.show()
            watermark_im.save("watermarked_image.png")  # Save the watermarked image in the same folder
            messagebox.showinfo("Success","Watermark applied and image saved as 'watermarked_image.png'")
            self.root.quit()
        except ValueError:
            messagebox.showerror("Invalid Input", "Coordinates must be integers.")
        except Exception as e:
            messagebox.showerror("Error", str(e))

    def clear_frame(self): 
        for widget in self.mainframe.winfo_children():
            widget.destroy()

if __name__ == '__main__':
    WatermarkApp()