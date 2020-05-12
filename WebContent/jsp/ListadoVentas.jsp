<%@ page
	import="java.util.List,
	model.Venta,
	model.controladores.VentaControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de ventas" />
</jsp:include>

<div class="container">
	<h4 style=text-align:start>Listado de Ventas</h4>
	<table class="table table-hover">
		<thead class="thead bg-success text-white">
			<tr>
				<th>Fecha de venta</th>
				<th>Precio de venta</th>
				<th>Cliente</th>
				<th>Coche</th>
				<th>Concesionario</th>
			</tr>
		</thead>
		<tbody>
			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Venta> ventas = VentaControlador.getControlador().findAll();
			for (Venta venta : ventas) {
			%>
			<tr>
				<td><a
					href="FichaVenta.jsp?idVenta=<%=venta.getId()%>"> <%=venta.getFecha()%>
				</a></td>
				<td><%=venta.getPrecioVenta()%></td>
				<td><%=venta.getCliente()%></td>
				<td><%=venta.getCoche()%></td>
				<td><%=venta.getConcesionario()%></td>
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de profesores termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn bg-success text-white" name="nuevo" value="Nuevo"
		onclick="window.location='FichaVenta.jsp?idVenta=0'" />
</div>
<%@ include file="pie.jsp"%>