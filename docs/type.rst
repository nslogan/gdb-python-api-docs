:py:class:`Type` --- Types from the inferior
============================================

TODO: Can I use the ``:source:`` directive to point at code outside of this repo?

.. **Source code:** :source:`/binutils-gdb/gdb/python/py-type.c`

--------------

GDB represents types from the inferior with the :py:class:`Type` class.

.. versionadded:: 7 (?) TODO

See:

- https://www.sphinx-doc.org/en/master/usage/extensions/doctest.html
- https://sphinx-tutorial.readthedocs.io/step-3/


.. note:: TODO(logan; better way of documenting this?) This attribute is
   not available for ``enum`` or ``static`` (as in C++) fields. The
   ``Optional[int | None]`` type hint results in ``int | None | None``,
   which is not what I want. If the attribute doesn't exist it will raise
   ``AttributeError`` (default Python behavior).



Convenience factory functions
-----------------------------

The :py:mod:`gdb` module provides factory functions to conveniently create
types, values, ..TODO(logan)..:

TODO: Not sure how Python docs typically represent optional positional arguments

..
   It seems like if I include the optional argument ' [, block]' in the
   signature the 'str' type isn't highlighted, even if I include a type with the
   'block'. I'll need to find an example somewhere of a function with types
   *and* optional arguments.

.. py:function:: gdb.lookup_type(name: str, block: Block | None = None) -> Type

   :param name: The name of the type to look up
   :param block: A :py:class:`Block` to scope the look up in (optional)

   This function looks up a type by its name, which must be a string.

   If block is given, then name is looked up in that scope. Otherwise, it is searched for globally.

   Ordinarily, this function will return an instance of gdb.Type. If the named type cannot be found, it will throw an exception.


Type object
-----------

So, I think my plan for documenting this section is to provide a simple C / C++
snippet defining some types for use in examples. I will define the minimum
number of types necessary to hit all of the attributes and methods. A future
improvement would be to also define some Rust types. I won't necessarily hit
all of the ``TYPE_CODE``'s, some are specific to Fortran or Pascal, and I'm not
interested right now in exploring those pieces (but would welcome
contributions!). I will need to do some explaining about the "inferior" and how
that impacts the size of types (and how to figure out what those sizes are).

..
   At least in GDB 12.1, gdb.Type() has no __init__ method, i.e. the constructor
   takes no arguments.

.. py:class:: Type()

   TODO: Description

   .. py:attribute:: alignof
      :type: int

      The alignment of this type, in bytes. Type alignment comes from the
      debugging information; if it was not specified, then GDB will use the
      relevant ABI to try to determine the alignment. In some cases, even this
      is not possible, and zero will be returned.

      Implemented in C function ``typy_get_alignof(...)``

      >>> # gdb.parse_and_eval("(int *)0").type.target().alignof
      >>> gdb.lookup_type('int').alignof
      4

   .. py:attribute:: code

      TODO

   .. py:attribute:: dynamic
      :type: bool

      TODO

   .. py:attribute:: name
      :type: str | None

      The name of this type. If this type has no name, then ``None`` is returned.

      TODO(logan): Why would a type not have a name? Given an example. An example I have seen is a pointer to a type.

      >>> gdb.lookup_type('int').name
      'int'
      >>> gdb.lookup_type('int').pointer().name
      >>> # Returns None

   .. py:attribute:: sizeof
      :type: int | None

      The size of this type, in target ``char`` units. Usually, a target's
      ``char`` type will be an 8-bit byte. However, on some unusual platforms,
      this type may have a different size. A dynamic type may not have a fixed
      size; in this case, this attribute's value will be ``None``.

   .. py:attribute:: tag
      :type: str | None

      TODO

   .. py:attribute:: objfile
      :type: Objfile | None

      TODO

   .. py:attribute:: is_scalar
      :type: bool

      TODO

   .. py:attribute:: is_signed
      :type: bool

      TODO

      .. warning::

         TODO: Also, add note about bug I found

   .. py:attribute:: is_array_like
      :type: bool

      TODO

      .. versionadded:: 14.1

   .. py:attribute:: is_string_like
      :type: bool

      TODO

      .. versionadded:: 14.1


   .. py:method:: Type.fields() -> list[Field] | None

   .. py:method:: Type.array(n1: int, n2: int | None = None)

   .. py:method:: Type.vector(n1: int, n2: int | None = None)

   .. py:method:: Type.const() -> Type

      Return a new :py:class:`Type` object which represents a const-qualified variant
      of this type.

   .. py:method:: Type.volatile() -> Type

   .. py:method:: Type.unqualified() -> Type

   .. py:method:: Type.range() -> tuple[int, int]

   .. py:method:: Type.reference() -> Type

      Return a new :py:class:`Type` object which represents a reference to this type.

   .. py:method:: Type.pointer() -> Type

      Return a new :py:class:`Type` object which represents a pointer to this type.

   .. py:method:: Type.strip_typedefs() -> Type

   .. py:method:: Type.target()

   .. py:method:: Type.template_argument(n: int, block: Block | None = None)

   .. py:method:: Type.optimized_out() -> Value



.. py:data:: TYPE_CODE_PTR

   The type is a pointer.

.. py:data:: TYPE_CODE_ARRAY

   TODO

.. py:data:: TYPE_CODE_STRUCT

   TODO

.. py:data:: TYPE_CODE_UNION

   TODO

.. py:data:: TYPE_CODE_ENUM

   TODO

.. py:data:: TYPE_CODE_FLAGS

   TODO

.. py:data:: TYPE_CODE_FUNC

   TODO

.. py:data:: TYPE_CODE_INT

   TODO

.. py:data:: TYPE_CODE_FLT

   TODO

.. py:data:: TYPE_CODE_VOID

   TODO

.. py:data:: TYPE_CODE_SET

   TODO

.. py:data:: TYPE_CODE_RANGE

   TODO

.. py:data:: TYPE_CODE_STRING

   TODO

.. py:data:: TYPE_CODE_BITSTRING

   TODO

.. py:data:: TYPE_CODE_ERROR

   TODO

.. py:data:: TYPE_CODE_METHOD

   TODO

.. py:data:: TYPE_CODE_METHODPTR

   TODO

.. py:data:: TYPE_CODE_MEMBERPTR

   TODO

.. py:data:: TYPE_CODE_REF

   TODO

.. py:data:: TYPE_CODE_RVALUE_REF

   TODO

.. py:data:: TYPE_CODE_CHAR

   TODO

.. py:data:: TYPE_CODE_BOOL

   TODO

.. py:data:: TYPE_CODE_COMPLEX

   TODO

.. py:data:: TYPE_CODE_TYPEDEF

   TODO

.. py:data:: TYPE_CODE_NAMESPACE

   TODO

.. py:data:: TYPE_CODE_DECFLOAT

   TODO

.. py:data:: TYPE_CODE_INTERNAL_FUNCTION

   TODO



Field object
------------

.. py:class:: Field()

   TODO: Description

   .. py:attribute:: bitpos
      :type: Optional[int]

      The value is the position, counting in bits, from the start of the
      containing type. Note that, in a dynamic type, the position of a field
      may not be constant. In this case, the value will be ``None``. Also, a
      dynamic type may have fields that do not appear in a corresponding
      concrete type.

      :raises AttributeError: This attribute is not available for ``enum`` or
       ``static`` (as in C++) fields.

   .. py:attribute:: name
      :type: str | None

      The name of the field, or ``None`` for anonymous fields.

----

TODO: These are just stub class definitions so that I can reference them

.. py:class:: Block()

   TODO

.. py:class:: Objfile()

   TODO

