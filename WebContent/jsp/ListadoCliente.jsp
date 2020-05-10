<%@ page
	import="java.util.List,
	model.Cliente,
	model.controladores.ClienteControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de clientes" />
</jsp:include>

<div class="container">
	<h1>Listado de Clientes</h1>
	<table class="table table-hover">
		<thead class="thead-dark">
			<tr>
				<th>DniNie</th>
				<th>Nombre</th>
				<th>Apellidos</th>
				<th>Fecha Nacimiento</th>
				<th>Localidad</th>
				<th>Activo</th>
			</tr>
		</thead>
		<tbody>
			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Cliente> clientes = ClienteControlador.getControlador().findAll();
			for (Cliente cli : clientes) {
			%>
			<tr>
				<td><a
					href="FichaCliente.jsp?idCliente=<%=cli.getId()%>"> <%=cli.getDniNie()%>
				</a></td>
				<td><%=cli.getNombre()%></td>
				<td><%=cli.getApellidos()%></td>
				<td><%=cli.getFechaNac()%></td>
				<td><%=cli.getLocalidad()%></td>
				<td><%=cli.getActivo()%></td>
				
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de profesores termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary" name="nuevo" value="Nuevo"
		onclick="window.location='FichaCliente.jsp?idCliente=0'" />
</div>
<%@ include file="pie.jsp"%>