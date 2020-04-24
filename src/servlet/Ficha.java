package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Concesionario;
import model.controladores.ConcesionarioControlador;
import utils.FormularioIncorrectoRecibidoException;

/**
 * Servlet implementation class Ficha
 */
@WebServlet(name= "Ficha", urlPatterns= { "/Ficha" })
public class Ficha extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Ficha() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Concesionario concesionario = new Concesionario();
		// buscamos c�mo conseguir el concesionario a editar, si existe se cargar� y si no, aparecer� como null
		try {
			int idConcesionario = getIntParameter(request, "idConcesionario");// necsitamos saber el id para acceder al 
			//concesionario que vamos a editar, si es nuevo, sale a 0
			concesionario = (Concesionario) ConcesionarioControlador.getControlador().find(idConcesionario);
			
		} catch (Exception e) {}
		
		// el Server puede llevar a cabo tres acciones:
		// "eliminar" identificamos esta acci�n porque recibiremos un par�metro con el nombre "eliminar" en el request
		// "guardar" esta acci�n se identificar� porque recibiremos un par�metro con el nombre "guardar" en el request
		// si no hay ninguna de las acciones anteriores, ser� que se quiere modificar

		// variable con el nobmre de la acci�n
		String mensajeAlUsuario = "";

		// Acci�n eliminar
		if(request.getParameter("eliminar") != null) {
			// intento eliminar el registro, si el borrado es correcto redirijo la petici�n hacia el listado de concesionarios
			try {
				ConcesionarioControlador.getControlador().remove(concesionario);
				response.sendRedirect(request.getContextPath() + "/Listado"); // hay que hacer la lista
			} catch (Exception e2) {
				mensajeAlUsuario = "No se puedo eliminar. Quiz�s haya restricciones asociadas a este registro";
			}
		}

		// Acci�n guardar
		if(request.getParameter("guardar") != null) {
			// primero obtenemos todos los datos del concesionario para luego guardarlos en la BBDD
			try {
				concesionario.setCif(getStringParameter(request, "cif"));
				concesionario.setNombre(getStringParameter(request, "nombre"));
				concesionario.setLocalidad(getStringParameter(request, "localidad"));

				ConcesionarioControlador.getControlador().save(concesionario);
				mensajeAlUsuario = "Guardado correctamente";
			} catch (FormularioIncorrectoRecibidoException e1) {
				throw new ServletException(e1);
			}
		}

		// Ahora mostramos la pantalla de respuesta al usuario
		response.getWriter().append("<!DOCTYPE html PUBLIC \\\"-//W3C//DTD XHTML 1.0 Transitional//EN\\\" \\\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\\">\r\n" +
				"<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" +
				"<head>\r\n" + 
				"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n" + 
				"<title>Documento sin t�tulo</title>\r\n" +
				"</head>\r\n" + 
				"<script>\r\n" +
				" function validateForm() {" +
				" var x = document.forms[\"form1\"][\"cif\"].value;" +
				" var y = document.forms[\"form1\"][\"nombre\"].value;" +
				" var z = document.forms[\"form1\"][\"localidad\"].value;" +
				" if(x == \"\") {" +
				" alert (\"No has insertado el CIF, lo has dejado vac�o\");" +
				" return false;" +
				" }" +
				" if(y == \"\") {" +
				" alert (\"No has insertado el NOMBRE, lo has dejado vac�o\");" +
				" return false;" +
				" }" +
				" if(z == \"\") {" +
				" alert (\"No has insertado la LOCALIDAD, lo has dejado vac�o\");" +
				" return false;" +
				" }" +
				" }" +
				"</script>\r\n" +
				"<body " +((mensajeAlUsuario != null && mensajeAlUsuario != "")? "onLoad=\"alert('" + mensajeAlUsuario + "');\"" : "")  + "\" />\r\n" +
				"<h1>Ficha de concesionario</h1>\r\n" + 
				"<a href=\"Listado\">Ir al listado de concesionario</a>" +
				"<form id=\"form1\" name=\"form1\" method=\"post\" action=\"Ficha\" onsubmit=\"return validateForm()\">\r\n" + 
				" <input type=\"hidden\" name=\"idConcesionario\" value=\"" + ((concesionario != null)? concesionario.getId() : "") + "\"\\>" +
				"  <p>\r\n" + 
				"    <label for=\"cif\">Cif:</label>\r\n" +
				"    <input name=\"cif\" type=\"text\" id=\"cif\"  value=\"" + ((concesionario != null)? concesionario.getCif() : "") + "\" />\r\n" + 
				"  </p>\r\n" +
				"  <p>\r\n" + 
				"    <label for=\"nombre\">Nombre: </label>\r\n" +  
				"    <input name=\"nombre\" type=\"text\" id=\"nombre\" value=\"" + ((concesionario != null)? concesionario.getNombre() : "") + "\" />\r\n" +
				"  </p>\r\n" +
				"  <p>\r\n" +
				"    <label for=\"localidad\">Localidad: </label>\r\n" + 
				"    <input name=\"localidad\" type=\"text\" id=\"localidad\" value=\"" + ((concesionario != null)? concesionario.getLocalidad() : "") + "\" />\r\n" +
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <input type=\"submit\" name=\"guardar\" value=\"Guardar\" />\r\n" + 
				"    <input type=\"submit\" name=\"eliminar\" value=\"Eliminar\" />\r\n" + 
				"  </p>\r\n" + 
				"</form>" +
				"</body>\r\n" + 
				"</html>\r\n" + 
				"");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	/**
	 * 
	 */
	
	public int getIntParameter (HttpServletRequest request, String nombreParametro) throws FormularioIncorrectoRecibidoException {
		try {
			return Integer.parseInt(request.getParameter(nombreParametro));
		} catch (Exception e) {
			throw new FormularioIncorrectoRecibidoException("No se ha recibido valor para el par�metro" + nombreParametro);
		}
	}
	
	/**
	 * 
	 */
	
	public String getStringParameter(HttpServletRequest request, String nombreParametro) throws FormularioIncorrectoRecibidoException {
		if(request.getParameter(nombreParametro) != null) {
			return request.getParameter(nombreParametro);
		}
		throw new FormularioIncorrectoRecibidoException("No se ha recibido valor del par�metro " + nombreParametro);
	}

}
