CREATE TABLE ESTADO_CIVIL(
    id_estado_civil NUMBER(38),
    nombre VARCHAR2(50),
    sigla VARCHAR2(5),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_estado_civil
    PRIMARY KEY (id_estado_civil)
);

CREATE TABLE TIPO_DOCUMENTO(
    id_tipo_documento NUMBER(38),
    nombre VARCHAR2(50),
    sigla VARCHAR2(5),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_tipo_documento
    PRIMARY KEY (id_tipo_documento)
);

CREATE TABLE GENERO(
    id_genero NUMBER(38),
    nombre VARCHAR2(50),
    sigla VARCHAR2(5),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_genero
    PRIMARY KEY (id_genero)
);

CREATE TABLE CATEGORIA(
    id_categoria NUMBER(38),
    nombre VARCHAR2(100),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_categoria
    PRIMARY KEY (id_categoria)
);

CREATE TABLE ESTADO_MESA(
    id_estado_mesa NUMBER(38),
    nombre VARCHAR2(50),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_estado_mesa
    PRIMARY KEY (id_estado_mesa)
);

CREATE TABLE METODO_PAGO(
    id_metodo_pago NUMBER(38),
    nombre VARCHAR2(50),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_metodo_pago
    PRIMARY KEY (id_metodo_pago)
);

CREATE TABLE CARGO_EMPLEADO(
    id_cargo_empleado NUMBER(38),
    nombre VARCHAR2(50),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_cargo_empleado
    PRIMARY KEY (id_cargo_empleado)
);

CREATE TABLE TIPO_CLIENTE(
    id_tipo_cliente NUMBER(38),
    nombre VARCHAR2(50),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_tipo_cliente
    PRIMARY KEY (id_tipo_cliente)
);

CREATE TABLE PERSONA(
    id_persona NUMBER(38),
    nombres VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE,
    numero_documento NUMBER(15) NOT NULL UNIQUE,
    celular VARCHAR2(15),
    correo VARCHAR2(100) UNIQUE,
    direccion VARCHAR2(250),
    id_estado_civil NUMBER(38) NOT NULL,
    id_tipo_documento NUMBER(38) NOT NULL,
    id_genero NUMBER(38) NOT NULL,
    id_usuario_registra NUMBER(38),
    id_usuario_actualiza NUMBER(38),
    fecha_registra DATE,
    fecha_actualiza DATE,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_persona
    PRIMARY KEY (id_persona),
    
    CONSTRAINT fk_estado_civil_persona
    FOREIGN KEY (id_estado_civil) 
    REFERENCES ESTADO_CIVIL(id_estado_civil),
    
    CONSTRAINT fk_tipo_documento_persona
    FOREIGN KEY (id_tipo_documento) 
    REFERENCES TIPO_DOCUMENTO(id_tipo_documento),
    
    CONSTRAINT fk_genero_persona
    FOREIGN KEY (id_genero) 
    REFERENCES GENERO(id_genero),
    
    CONSTRAINT ck_correo
    CHECK (correo LIKE '%@%.%')
);

CREATE TABLE CLIENTE(
    id_cliente NUMBER(38),
    id_persona NUMBER(38) NOT NULL,
    id_tipo_cliente NUMBER(38) NOT NULL,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_cliente
    PRIMARY KEY (id_cliente),
    
    CONSTRAINT fk_persona_cliente
    FOREIGN KEY (id_persona) 
    REFERENCES PERSONA(id_persona),
    
    CONSTRAINT fk_tipo_cliente_cliente
    FOREIGN KEY (id_tipo_cliente) 
    REFERENCES TIPO_CLIENTE(id_tipo_cliente)
);

CREATE TABLE EMPLEADO(
    id_empleado NUMBER(38),
    nombre VARCHAR2(100) NOT NULL,
    fecha_contrato DATE,
    telefono VARCHAR2(20),
    correo VARCHAR2(100),
    id_cargo_empleado NUMBER(38) NOT NULL,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_empleado
    PRIMARY KEY (id_empleado),
    
    CONSTRAINT fk_cargo_empleado
    FOREIGN KEY (id_cargo_empleado) 
    REFERENCES CARGO_EMPLEADO(id_cargo_empleado)
);

CREATE TABLE HORARIO_EMPLEADO(
    id_horario_empleado NUMBER(38),
    hora_inicio DATE,
    hora_fin DATE,
    dia_semana VARCHAR2(20),
    id_empleado NUMBER(38) NOT NULL,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_horario_empleado
    PRIMARY KEY (id_horario_empleado),
    
    CONSTRAINT fk_empleado_horario
    FOREIGN KEY (id_empleado) 
    REFERENCES EMPLEADO(id_empleado)
);

CREATE TABLE MESA(
    id_mesa NUMBER(38),
    capacidad NUMBER,
    id_estado_mesa NUMBER(38) NOT NULL,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_mesa
    PRIMARY KEY (id_mesa),
    
    CONSTRAINT fk_estado_mesa
    FOREIGN KEY (id_estado_mesa) 
    REFERENCES ESTADO_MESA(id_estado_mesa)
);

CREATE TABLE RESERVA(
    id_reserva NUMBER(38),
    cantidad_personas NUMBER,
    fecha_reserva DATE,
    estado VARCHAR2(20),
    id_cliente NUMBER(38) NOT NULL,
    
    CONSTRAINT pk_reserva
    PRIMARY KEY (id_reserva),
    
    CONSTRAINT fk_cliente_reserva
    FOREIGN KEY (id_cliente) 
    REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE RESERVA_MESA(
    id_reserva NUMBER(38),
    id_mesa NUMBER(38),
    
    CONSTRAINT pk_reserva_mesa
    PRIMARY KEY (id_reserva, id_mesa),
    
    CONSTRAINT fk_reserva_mesa_reserva
    FOREIGN KEY (id_reserva) 
    REFERENCES RESERVA(id_reserva),
    
    CONSTRAINT fk_reserva_mesa_mesa
    FOREIGN KEY (id_mesa) 
    REFERENCES MESA(id_mesa)
);

CREATE TABLE PEDIDO(
    id_pedido NUMBER(38),
    fecha_pedido TIMESTAMP,
    estado_pedido VARCHAR2(20),
    id_cliente NUMBER(38) NOT NULL,
    id_empleado NUMBER(38) NOT NULL,
    id_mesa NUMBER(38) NOT NULL,
    id_reserva NUMBER(38),
    id_metodo_pago NUMBER(38) NOT NULL,
    total NUMBER(10,2),
    fecha_registra DATE,
    fecha_actualiza DATE,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_pedido
    PRIMARY KEY (id_pedido),
    
    CONSTRAINT fk_cliente_pedido
    FOREIGN KEY (id_cliente) 
    REFERENCES CLIENTE(id_cliente),
    
    CONSTRAINT fk_empleado_pedido
    FOREIGN KEY (id_empleado) 
    REFERENCES EMPLEADO(id_empleado),
    
    CONSTRAINT fk_mesa_pedido
    FOREIGN KEY (id_mesa) 
    REFERENCES MESA(id_mesa),
    
    CONSTRAINT fk_reserva_pedido
    FOREIGN KEY (id_reserva) 
    REFERENCES RESERVA(id_reserva),
    
    CONSTRAINT fk_metodo_pago_pedido
    FOREIGN KEY (id_metodo_pago) 
    REFERENCES METODO_PAGO(id_metodo_pago)
);

CREATE TABLE DETALLE_PEDIDO(
    id_detalle_pedido NUMBER(38),
    id_pedido NUMBER(38) NOT NULL,
    id_producto NUMBER(38) NOT NULL,
    cantidad NUMBER,
    subtotal NUMBER(10,2),
    notas VARCHAR2(250),
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_detalle_pedido
    PRIMARY KEY (id_detalle_pedido),
    
    CONSTRAINT fk_pedido_detalle
    FOREIGN KEY (id_pedido) 
    REFERENCES PEDIDO(id_pedido),
    
    CONSTRAINT fk_producto_detalle
    FOREIGN KEY (id_producto) 
    REFERENCES PRODUCTO(id_producto)
);

CREATE TABLE PRODUCTO(
    id_producto NUMBER(38),
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(250),
    tamano VARCHAR2(20),
    precio NUMBER(10,2),
    id_categoria NUMBER(38) NOT NULL,
    id_usuario_registra NUMBER(38),
    id_usuario_actualiza NUMBER(38),
    fecha_registro DATE,
    fecha_actualiza DATE,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_producto
    PRIMARY KEY (id_producto),
    
    CONSTRAINT fk_categoria_producto
    FOREIGN KEY (id_categoria) 
    REFERENCES CATEGORIA(id_categoria)
);

CREATE TABLE PROMOCION(
    id_promocion NUMBER(38),
    nombre VARCHAR2(100) NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    descripcion VARCHAR2(250),
    id_usuario_registra NUMBER(38),
    id_usuario_actualiza NUMBER(38),
    fecha_registro DATE,
    fecha_actualiza DATE,
    estado NUMBER(1) DEFAULT 1,
    
    CONSTRAINT pk_promocion
    PRIMARY KEY (id_promocion)
);

CREATE TABLE PROMOCION_PRODUCTO(
    id_promocion NUMBER(38),
    id_producto NUMBER(38),
    
    CONSTRAINT pk_promocion_producto
    PRIMARY KEY (id_promocion, id_producto),
    
    CONSTRAINT fk_promocion_producto_promocion
    FOREIGN KEY (id_promocion) 
    REFERENCES PROMOCION(id_promocion),
    
    CONSTRAINT fk_promocion_producto_producto
    FOREIGN KEY (id_producto) 
    REFERENCES PRODUCTO(id_producto)
);
