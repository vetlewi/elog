# README #

Simple library to read, write and traverse XML files.

### Usage ###

This is a simple implementation of XML functions for writing and
reading XML files. For writing an XML file from scratch, following
functions can be used:


```
#!c

   writer = mxml_open_file(file_name);
     mxml_start_element(writer, name);
     mxml_write_attribute(writer, name, value);
     mxml_write_value(writer, value);
     mxml_end_element(writer); 
     ...
   mxml_close_file(writer);

```

To read an XML file, the function


```
#!c

   tree = mxml_parse_file(file_name, error, sizeof(error));

```

is used. It parses the complete XML file and stores it in a
hierarchical tree in memory. Nodes in that tree can be searched
for with


```
#!c

   mxml_find_node(tree, xml_path);

```

or


```
#!c

   mxml_find_nodes(tree, xml_path, &nodelist);

```

which support a subset of the XPath specification. Another set of
functions is availabe to retrieve attributes and values from nodes
in the tree and for manipulating nodes, like replacing, adding and
deleting nodes.
   


### Copywright ###

GNU General Public License V2

### Contact ###
Stefan Ritt <stefan.ritt@psi.ch>