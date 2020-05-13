<%@ page
	import="java.util.List,
	model.Cliente,
	model.controladores.ClienteControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de clientes" />
</jsp:include>

<%!
		public int getOffset(String param) {

		int offset = Integer.parseInt(param);

		if (offset > 1) {

			return 5 * offset;
		} else {
			return 0;
		}

	}%>
<%!private int offset, paginationIndex;%>

<%
	offset = getOffset(request.getParameter("idPag"));
	paginationIndex = Integer.parseInt(request.getParameter("idPag"));
%>

<div class="container">
	<h4 style="text-align: start">Listado de Clientes</h4>
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
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
				// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
				List<Cliente> clientes = ClienteControlador.getControlador().findAllLimited(5, offset);
				for (Cliente cli : clientes) {
			%>
			<tr>
				<td><a href="FichaCliente.jsp?idCliente=<%=cli.getId()%>">
						<%=cli.getDniNie()%>
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
	<input type="submit" class="btn bg-success text-white" name="nuevo"
		value="Nuevo" onclick="window.location='FichaCliente.jsp?idCliente=0'" />

	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="?idPag=1">First</a></li>
		<%
			int num = ClienteControlador.getControlador().numRegistros();
			double size = Math.ceil(num / 5);

			if (paginationIndex > 1) {
		%>
		<li class="page-item"><a class="page-link"
			href="?idPag=<%=paginationIndex - 1%>"><%=paginationIndex - 1%></a></li>

		<%
			}
		%>
		<li class="page-item active"><a class="page-link"
			href="?idPag=<%=paginationIndex%>"><%=paginationIndex%></a></li>
		<%
			if (paginationIndex < size) {
		%>
		<li class="page-item"><a class="page-link"
			href="?idPag=<%=paginationIndex + 1%>"><%=paginationIndex + 1%></a></li>
		<%
			}
		%>

		<li class="page-item"><a class="page-link bg-danger text-white"
			href="?idPag=<%=Math.round(size)%>">Last</a></li>
	</ul>


</div>
<%@ include file="pie.jsp"%>