<%@ page
	import="java.util.List, 
	java.awt.Checkbox,
	java.util.HashMap,
	java.util.Date,
	java.text.SimpleDateFormat,
	utils.RequestUtils,
	model.Cliente,
	model.Venta,
	model.Concesionario,
	model.Coche,
	model.controladores.CocheControlador,
	model.controladores.ConcesionarioControlador,
	model.controladores.VentaControlador,
	model.controladores.ClienteControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Ficha de venta" />
</jsp:include>

<%
//Damos el formato a la fecha
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

	// Obtengo una HashMap con todos los parámetros del request, sea este del tipo que sea;
HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);



// Para plasmar la información de un profesor determinado utilizaremos un parámetro, que debe llegar a este Servlet obligatoriamente
// El parámetro se llama "idProfesor" y gracias a él podremos obtener la información del profesor y mostrar sus datos en pantalla
Venta v = null;
// Obtengo el profesor a editar, en el caso de que el profesor exista se cargarán sus datos, en el caso de que no exista quedará a null
try {
	int idVenta = RequestUtils.getIntParameterFromHashMap(hashMap, "idVenta"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
	// de profesor obtendríamos el valor 0 como idProfesor
	
	
	if (idVenta != 0) {
		v = (Venta) VentaControlador.getControlador().find(idVenta);
	}
} catch (Exception e) {
	e.printStackTrace();
}
// Inicializo unos valores correctos para la presentación del profesor
if (v == null) {
	v = new Venta();
}
if (v.getFecha() == null)
	v.setFecha(null);

if (v.getPrecioVenta() == 0f)
	v.setPrecioVenta(0f);

if (v.getCliente() == null)
	v.setCliente((Cliente) ClienteControlador.getControlador().find(1));

if (v.getCoche() == null)
	v.setCoche((Coche) CocheControlador.getControlador().find(1));

if (v.getConcesionario() == null)
	v.setConcesionario((Concesionario) ConcesionarioControlador.getControlador().find(1));

// Ahora debo determinar cuál es la acción que este página debería llevar a cabo, en función de los parámetros de entrada al Servlet.
// Las acciones que se pueden querer llevar a cabo son tres:
//    - "eliminar". Sé que está es la acción porque recibiré un un parámetro con el nombre "eliminar" en el request
//    - "guardar". Sé que está es la acción elegida porque recibiré un parámetro en el request con el nombre "guardar"
//    - Sin acción. En este caso simplemente se quiere editar la ficha

// Variable con mensaje de información al usuario sobre alguna acción requerida
String mensajeAlUsuario = "";

// Primera acción posible: eliminar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
	// Intento eliminar el registro, si el borrado es correcto redirijo la petición hacia el listado de profesores
	try {
		VentaControlador.getControlador().remove(v);
		response.sendRedirect(request.getContextPath() + "/jsp/ListadoVentas.jsp"); // Redirección del response hacia el listado
	} catch (Exception ex) {
		mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
	}
}

// Segunda acción posible: guardar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
	// Obtengo todos los datos del profesor y los almaceno en BBDD
	try {
		
		v.setFecha(sdf.parse(RequestUtils.getStringParameterFromHashMap(hashMap, "fecha")));
		
		v.setPrecioVenta(Float.parseFloat(RequestUtils.getStringParameterFromHashMap(hashMap, "precioVenta")));
		
		v.setCliente((Cliente)ClienteControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idCliente")));

		v.setCoche((Coche)CocheControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idCoche")));
		
		v.setConcesionario((Concesionario)ConcesionarioControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idConcesionario")));


		// Finalmente guardo el objeto de tipo profesor 
		VentaControlador.getControlador().save(v);
		mensajeAlUsuario = "Guardado correctamente";
	} catch (Exception e) {
		throw new ServletException(e);
	}
}

// Ahora muestro la pantalla de respuesta al usuario
%>

<div class="container py-3">
	<%
		String tipoAlerta = "alert-success";
	if (mensajeAlUsuario != null && mensajeAlUsuario != "") {
		if (mensajeAlUsuario.startsWith("ERROR")) {
			tipoAlerta = "alert-danger";
		}
	%>
	<div class="alert <%=tipoAlerta%> alert-dismissible fade show">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		<%=mensajeAlUsuario%>
	</div>
	<%
		}
	%>
	<div class="row">
		<div class="mx-auto col-sm-6">
			<!-- form user info -->
			<div class="card">
				<div class="card-header bg-success text-white">
					<h4 class="mb-0" style="text-align:center">Ficha de cliente</h4>
				</div>
				<div class="card-body">

					<a href="ListadoVentas.jsp">Ir al listado de ventas</a>
					<form id="form1" name="form1" method="post"
						action="FichaVenta.jsp" enctype="multipart/form-data"
						class="form" role="form" autocomplete="off">
						<p />
						<input type="hidden" name="idVenta"
							value="<%=v.getId()%>" />
							
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="fecha">Fecha</label>
							<div class="col-lg-9">
								<input name="fecha" class="form-control" type="text"
									id="fecha" value="<%= ((v.getFecha() != null) ? sdf.format(v.getFecha()) : "") %>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="precioVenta">Precio Venta</label>
							<div class="col-lg-9">
								<input name="precioVenta" class="form-control" type="text"
									id="precioVenta" value="<%= v.getPrecioVenta() %>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idCliente">Cliente</label>
							<div class="col-lg-9">
								<select name="idCliente" id="idCliente"
									class="form-control">
									<%
										// Inserto los valores de la tipología del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Cliente> clientes = ClienteControlador.getControlador().findAll();
									for (Cliente clie : clientes) {
									%>
									<option value="<%=clie.getId()%>"
										<%=((clie.getId() == v.getCliente().getId()) ? "selected=\"selected\"" : "")%>><%=clie.getNombre() %></option>
									<% } %>
								</select>
							</div>
						</div>
						
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idCoche">Coche</label>
							<div class="col-lg-9">
								<select name="idCoche" id="idCoche"
									class="form-control">
									<%
										// Inserto los valores de la tipología del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Coche> coches = CocheControlador.getControlador().findAll();
									for (Coche coc : coches) {
									%>
									<option value="<%=coc.getId()%>"
										<%=((coc.getId() == v.getCoche().getId()) ? "selected=\"selected\"" : "") %>><%=coc.getModelo() %></option>
									<% } %>
								</select>
							</div>
						</div>
						
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idConcesionario">Concesionario</label>
							<div class="col-lg-9">
								<select name="idConcesionario" id="idConcesionario"
									class="form-control">
									<%
										// Inserto los valores de la tipología del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Concesionario> concesionarios = ConcesionarioControlador.getControlador().findAll();
									for (Concesionario con: concesionarios) {
									%>
									<option value="<%=con.getId()%>"
										<%=((con.getId() == v.getConcesionario().getId()) ? "selected=\"selected\"" : "") %>><%=con.getNombre() %></option>
									<% } %>
								</select>
							</div>
						</div>
	
						<div class="form-group row">
							<div class="col-lg-9">
								<input type="submit" name="guardar" class="btn bg-success text-white"
									value="Guardar" /> <input type="submit" name="eliminar"
									class="btn btn-secondary" value="Eliminar" />
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="pie.jsp"%>