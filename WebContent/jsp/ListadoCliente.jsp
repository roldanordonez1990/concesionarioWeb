<%@ page
	import="java.util.List,
	model.Cliente,
	model.controladores.ClienteControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de clientes" />
</jsp:include>

<div class="container">
	<h4 style=text-align:start>Listado de Clientes</h4>
	<table class="table table-hover">
		<thead class="thead bg-success text-white">
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
				// Hasta la fila anterior ha llegado la primera fila de t�tulos de la tabla de profesores del centro educativo
			// En las siguietnes l�neas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
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
	<input type="submit" class="btn bg-success text-white" name="nuevo" value="Nuevo"
		onclick="window.location='FichaCliente.jsp?idCliente=0'" />
</div>
<%@ include file="pie.jsp"%>