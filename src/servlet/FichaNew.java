package servlet;

import java.io.IOException;
     
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Concesionario;
import model.controladores.ConcesionarioControlador;
import utils.RequestUtils;
import utils.SuperTipoServlet;


/**
 * Servlet implementation class FichaNew
 */
@WebServlet(name= "FichaNew", urlPatterns= { "/FichaNew" })
public class FichaNew extends SuperTipoServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FichaNew() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Obtengo una HashMap con todos los par�metros del request, sea este del tipo que sea;
		HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);
		
		// Para plasmar la informaci�n de un concesionario determinado utilizaremos un par�metro, que debe llegar a este Servlet obligatoriamente
		// El par�metro se llama "idConcesionario" y gracias a �l podremos obtener la informaci�n del concesionario y mostrar sus datos en pantalla
		Concesionario concesionario = null;
		// Obtengo el concesionario a editar, en el caso de que el profesor exista se cargar�n sus datos, en el caso de que no exista quedar� a null
		try {
			int idConcesionario = RequestUtils.getIntParameterFromHashMap(hashMap, "idConcesionario"); // Necesito obtener el id del concesionario que se quiere editar. En caso de un alta
			// de concesionario obtendr�amos el valor 0 como idConcesionario
			if (idConcesionario != 0) {
				concesionario = (Concesionario) ConcesionarioControlador.getControlador().find(idConcesionario);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// Inicializo unos valores correctos para la presentaci�n del concesionario
		if (concesionario == null) {
			concesionario = new Concesionario();
		}
		if (concesionario.getCif() == null) concesionario.setCif("");
		if (concesionario.getNombre() == null) concesionario.setNombre("");
		if (concesionario.getLocalidad() == null) concesionario.setLocalidad("");
	
		
		
		// Ahora debo determinar cu�l es la acci�n que este p�gina deber�a llevar a cabo, en funci�n de los par�metros de entrada al Servlet.
		// Las acciones que se pueden querer llevar a cabo son tres:
		//    - "eliminar". S� que est� es la acci�n porque recibir� un un par�metro con el nombre "eliminar" en el request
		//    - "guardar". S� que est� es la acci�n elegida porque recibir� un par�metro en el request con el nombre "guardar"
		//    - Sin acci�n. En este caso simplemente se quiere editar la ficha
		
		// Variable con mensaje de informaci�n al usuario sobre alguna acci�n requerida
		String mensajeAlUsuario = "";
		
		// Primera acci�n posible: eliminar
		if (RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
			// Intento eliminar el registro, si el borrado es correcto redirijo la petici�n hacia el listado de concesionarios
			try {
				ConcesionarioControlador.getControlador().remove(concesionario);
				response.sendRedirect(request.getContextPath() + "/Listado"); // Redirecci�n del response hacia el listado
			}
			catch (Exception ex) {
				mensajeAlUsuario = "Imposible eliminar. Es posible que existan restricciones.";
			}
		}
		
		// Segunda acci�n posible: guardar
		if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
			// Obtengo todos los datos del concesionario y los almaceno en BBDD
			try {
				concesionario.setCif(RequestUtils.getStringParameterFromHashMap(hashMap, "cif"));
				concesionario.setNombre(RequestUtils.getStringParameterFromHashMap(hashMap, "nombre"));
				concesionario.setLocalidad(RequestUtils.getStringParameterFromHashMap(hashMap, "localidad"));
				byte[] posibleImagen = RequestUtils.getByteArrayFromHashMap(hashMap, "ficheroImagen");
				if (posibleImagen != null && posibleImagen.length > 0) {
					concesionario.setImagen(posibleImagen);
				}
				
				// Finalmente guardo el objeto de tipo concesionario 
				ConcesionarioControlador.getControlador().save(concesionario);
				mensajeAlUsuario = "Guardado correctamente";
			} catch (Exception e) {
				throw new ServletException(e);
			}
		}
		
		
		
		// Ahora muestro la pantalla de respuesta al usuario
		response.getWriter().append("<!DOCTYPE html PUBLIC \\\"-//W3C//DTD XHTML 1.0 Transitional//EN\\\" \\\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\\">\r\n" +
				"<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" +
				"<head>\r\n" + 
				"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n" + 
				"<title>Ficha concesionario</title>\r\n" +
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
				"<p>\r\n" + 
				"<a href=\"Listado\">Ir al listado de concesionario</a>" +
				"</p>\r\n" + 
				"<form id=\"form1\" name=\"form1\" method=\"post\" action=\"FichaNew\" onsubmit=\"return validateForm()\" enctype=\"multipart/form-data\">\r\n" + 
				" <img src=\"utils/DownloadImagenConcesionario?idConcesionario=" + concesionario.getId() + "\" width='150px' height='150px'/>" +
				" <input type=\"hidden\" name=\"idConcesionario\" value=\"" + concesionario.getId() + "\"\\>" +
				"  <p>\r\n" + 
				"    <label for=\"ficheroImagen\">Imagen:</label>\r\n" + 
				"    <input name=\"ficheroImagen\" type=\"file\" id=\"ficheroImagen\" />\r\n" + 
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <label for=\"cif\">Cif:</label>\r\n" + 
				"    <input name=\"cif\" type=\"text\" id=\"cif\"  value=\"" + concesionario.getCif() + "\" />\r\n" + 
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <label for=\"nombre\">Nombre:</label>\r\n" + 
				"    <input name=\"nombre\" type=\"text\" id=\"nombre\" value=\"" + concesionario.getNombre() + "\" />\r\n" + 
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <label for=\"localidad\">Localidad:</label>\r\n" + 
				"    <input name=\"localidad\" type=\"text\" id=\"localidad\" value='" + concesionario.getLocalidad() + "'/>\r\n" + 
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <input type=\"submit\" name=\"guardar\" value=\"Guardar\" />\r\n" + 
				"    <input type=\"submit\" name=\"eliminar\" value=\"Eliminar\" />\r\n" + 
				"  </p>\r\n" + 
				"</form>");
				response.getWriter().append(this.getPieHTML());
	}

}
