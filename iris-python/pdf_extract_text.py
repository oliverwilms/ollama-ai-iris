from PyPDF2 import PdfReader

def xtract_text(file_path: str):
    # Open the PDF file
    pdfFile = open(file_path, 'rb')
    # Create a PdfReader object to read the file
    pdfReader = PdfReader(pdfFile)
    # Get the number of pages in the PDF
    numOfPages = len(pdfReader.pages)
    # Loop through all the pages and extract text
    text = ''
    for i in range(0, numOfPages):
        pageObj = pdfReader.pages[i]
        text = text + pageObj.extract_text()
    # Close the PDF file object
    pdfFile.close()
    return text
