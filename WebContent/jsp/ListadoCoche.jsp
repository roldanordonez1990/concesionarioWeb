<%@ page
	import="java.util.List,
	model.Fabricante,
	model.controladores.FabricanteControlador,
	model.Coche,
	model.controladores.CocheControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de coches" />
</jsp:include>

<div class="container">
	<h1>Listado de Coches</h1>
	<table class="table table-hover">
		<thead class="thead-dark">
			<tr>
				<th>Bastidor</th>
				<th>Fabricante</th>
				<th>Color</th>
				<th>Modelo</th>
			</tr>
		</thead>
		<tbody>
			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Coche> coche = CocheControlador.getControlador().findAll();
			for (Coche co : coche) {
			%>
			<tr>
				<td><a
					href="FichaCoche.jsp?idCoche=<%=co.getId()%>"> <%=co.getBastidor()%>
				</a></td>
				<td><%=co.getFabricante()%></td>
				<td><%=co.getColor()%></td>
				<td><%=co.getModelo()%></td>
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de profesores termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary" name="nuevo" value="Nuevo"
		onclick="window.location='FichaCoche.jsp?idCoche=0'" />
</div>
<%@ include file="pie.jsp"%>