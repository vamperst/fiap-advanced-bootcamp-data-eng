from bs4 import BeautifulSoup
import markdownify

# Load the HTML content from the file
file_path = 'consumindo.html'
with open(file_path, 'r', encoding='utf-8') as file:
    html_content = file.read()

# Parse the HTML using BeautifulSoup
soup = BeautifulSoup(html_content, 'html.parser')

# Convert HTML to Markdown using markdownify, which will handle tag-to-markdown conversion
markdown_content = markdownify.markdownify(str(soup), heading_style="ATX")

# Translate the markdown content to Portuguese (simplified example using basic replacement)
# Here, I'll output the markdown result assuming that the translation will be handled separately
with open(f'downloads/pagina3.md', 'a') as f:
    f.write(markdown_content)
    f.close()