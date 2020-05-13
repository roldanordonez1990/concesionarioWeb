<%@page import="java.text.SimpleDateFormat"%>
<%@page 

	import="java.util.List, 
	java.util.HashMap,
	utils.RequestUtils,
	model.Coche,
	model.Fabricante,
	model.controladores.FabricanteControlador,
	model.controladores.CocheControlador"%>
	

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Ficha de coche" />
</jsp:include>

<%
	// Obtengo una HashMap con todos los par�metros del request, sea este del tipo que sea;
HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);



// Para plasmar la informaci�n de un profesor determinado utilizaremos un par�metro, que debe llegar a este Servlet obligatoriamente
// El par�metro se llama "idProfesor" y gracias a �l podremos obtener la informaci�n del profesor y mostrar sus datos en pantalla
Coche co = null;
// Obtengo el profesor a editar, en el caso de que el profesor exista se cargar�n sus datos, en el caso de que no exista quedar� a null
try {
	int idCoche = RequestUtils.getIntParameterFromHashMap(hashMap, "idCoche"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
	// de profesor obtendr�amos el valor 0 como idProfesor
	if (idCoche != 0) {
		co = (Coche) CocheControlador.getControlador().find(idCoche);
	}
} catch (Exception e) {
	e.printStackTrace();
}
// Inicializo unos valores correctos para la presentaci�n del profesor
if (co == null) {
	co = new Coche();
}
if (co.getBastidor() == null)
	co.setBastidor("");
if (co.getColor() == null)
	co.setColor("");
if (co.getModelo() == null)
	co.setModelo("");
if (co.getFabricante() == null)
	co.setFabricante((Fabricante) FabricanteControlador.getControlador().find(1));



// Ahora debo determinar cu�l es la acci�n que este p�gina deber�a llevar a cabo, en funci�n de los par�metros de entrada al Servlet.
// Las acciones que se pueden querer llevar a cabo son tres:
//    - "eliminar". S� que est� es la acci�n porque recibir� un un par�metro con el nombre "eliminar" en el request
//    - "guardar". S� que est� es la acci�n elegida porque recibir� un par�metro en el request con el nombre "guardar"
//    - Sin acci�n. En este caso simplemente se quiere editar la ficha

// Variable con mensaje de informaci�n al usuario sobre alguna acci�n requerida
String mensajeAlUsuario = "";

// Primera acci�n posible: eliminar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
	// Intento eliminar el registro, si el borrado es correcto redirijo la petici�n hacia el listado de profesores
	try {
		CocheControlador.getControlador().remove(co);
		response.sendRedirect(request.getContextPath() + "/jsp/ListadoCoche.jsp"); // Redirecci�n del response hacia el listado
	} catch (Exception ex) {
		mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
	}
}

// Segunda acci�n posible: guardar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
	// Obtengo todos los datos del profesor y los almaceno en BBDD
	try {
		co.setBastidor(RequestUtils.getStringParameterFromHashMap(hashMap, "bastidor"));
		co.setColor(RequestUtils.getStringParameterFromHashMap(hashMap, "color"));
		co.setModelo(RequestUtils.getStringParameterFromHashMap(hashMap, "modelo"));
		co.setFabricante((Fabricante) FabricanteControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idFabricante")));

		// Finalmente guardo el objeto de tipo profesor 
		CocheControlador.getControlador().save(co);
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
					<h4 class="mb-0" style="text-align:center">Ficha de coche</h4>
				</div>
				<div class="card-body">

					<a href="ListadoCoche.jsp">Ir al listado de coche</a>
					<form id="form1" name="form1" method="post"
						action="FichaCoche.jsp" enctype="multipart/form-data"
						class="form" role="form" autocomplete="off">
						<p />
						<input type="hidden" name="idCoche"
							value="<%=co.getId()%>" />
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="bastidor">Bastidor:</label>
							<div class="col-lg-9">
								<input name="bastidor" class="form-control" type="text"
									id="bastidor" value="<%=co.getBastidor()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="color">Color:</label>
							<div class="col-lg-9">
								<input name="color" class="form-control" type="text"
									id="color" value="<%=co.getColor()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="modelo">Modelo:</label>
							<div class="col-lg-9">
								<input name="modelo" class="form-control" type="text"
									id="modelo" value="<%=co.getModelo()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idFabricante">Fabricante:</label>
							<div class="col-lg-9">
								<select name="idFabricante" id="idFabricante"
									class="form-control">
									<%
										// Inserto los valores de la tipolog�a del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Fabricante> fabricantes = FabricanteControlador.getControlador().findAll();
									for (Fabricante fab : fabricantes) {
									%>
									<option value="<%=fab.getId()%>"
										<%=((fab.getId() == co.getFabricante().getId()) ? "selected=\"selected\"" : "")%>><%=fab.getNombre()%></option>
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