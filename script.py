import os
import glob
import re
from lxml import etree

# Ruta al archivo XSLT
xslt_file = 'ibatis2mybatis.xslt'

# Ruta al archivo de salida
output_folder = 'mybatis/include/'

# Lista de archivos XML
xml_files = glob.glob('xml/include/*.xml')

# Lista de documentos XML
xml_docs = []

# Cargar archivo XML y agregarlo a la lista de documentos
for xml_file in xml_files:
    xml_doc = etree.parse(xml_file)
    xml_docs.append(xml_doc)

# Cargar hoja de estilo XSLT
xslt_doc = etree.parse(xslt_file)

# Crear transformador
transformer = etree.XSLT(xslt_doc)

# Transformar cada documento XML y escribir resultado en archivo de salida
for i, xml_doc in enumerate(xml_docs):
    result = transformer(xml_doc)
    result_str = str(result)
    regex = r"#(\w+)(?::\w+)?[#}]"
    output = re.sub(regex, r'#{\1}', result_str)
    type_aliases = xml_doc.xpath('//typeAlias')
    new_doc = etree.Element('typeAliases')
    for type_alias in type_aliases:
        new_doc.insert(0, type_alias)
    xml_filename = os.path.basename(xml_files[i])
    output_filename = os.path.join(output_folder, xml_filename)
    with open(output_filename, 'wb') as f:
        f.write(output.encode('utf-8'))
    
