<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  <% String tituloDePagina = request.getParameter("tituloDePagina"); %>
  <title><%= (tituloDePagina != null)? tituloDePagina : "Sin t�tulo" %></title>
</head>
<body>

<div class="container-fluid">
<nav class="navbar navbar-expand-sm navbar-dark bg-dark">
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#menu">
         <span class="navbar-toggler-icon"></span>
     </button>
     <div class="collapse navbar-collapse justify-content-center " id="menu">
     
     
          <nav class="navbar-nav">
       
          	  <a class="nav-link text-white" href=../index.html>Inicio</a>
              <a class="nav-link text-white" href=ListadoConcesionario.jsp>Concesionario</a>
              <a class="nav-link text-white" href=ListadoCliente.jsp>Cliente</a>
              <a class="nav-link text-white" href=ListadoCoche.jsp>Coche</a>
              <a class="nav-link text-white" href=ListadoFabricante.jsp>Fabricante</a>
              <a class="nav-link text-white" href=ListadoVentas.jsp>Ventas</a>
             
          </nav>
     </div>
</nav>
</div>


