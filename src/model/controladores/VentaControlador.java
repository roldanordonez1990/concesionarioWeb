package model.controladores;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.Query;

import model.Coche;
import model.Controlador;
import model.Fabricante;
import model.Venta;

public class VentaControlador extends Controlador {

	private static VentaControlador controlador = null;

	public VentaControlador() {
		super(Venta.class, "VentaDeCoches");
	}

	/**
	 * 
	 */
	
	public static VentaControlador getControlador () {
		if (controlador == null) {
			controlador = new VentaControlador();
		}
		return controlador;
	}
	
	/**
	 *  
	 */
	public Venta find (int id) {
		return (Venta) super.find(id);
	}
	
	/**
	 * 
	 * @return
	 */
	public Venta findFirst () {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Venta c order by c.id", Venta.class);
			Venta resultado = (Venta) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		}
		catch (NoResultException nrEx) {
			return null;
		}
	}
	
	/**
	 * 
	 * @return
	 */
	public Venta findLast () {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Venta c order by c.id desc", Venta.class);
			Venta resultado = (Venta) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		}
		catch (NoResultException nrEx) {
			return null;
		}
	}
	
	/**
	 * 
	 */
	
	public Venta findNext (Venta c) {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Venta c where c.id > :idActual order by c.id", Venta.class);
			q.setParameter("idActual", c.getId());
			Venta resultado = (Venta) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		}
		catch (NoResultException nrEx) {
			return null;
		}
	}
	
	/**
	 * 
	 * @return
	 */
	public Venta findPrevious (Venta c) {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Venta c where c.id < :idActual order by c.id desc", Venta.class);
			q.setParameter("idActual", c.getId());
			Venta resultado = (Venta) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		}
		catch (NoResultException nrEx) {
			return null;
		}
	}
	
	/**
	 * 
	 */
	
	public List<Venta> findAll () {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		Query q = em.createQuery("SELECT c FROM Venta c", Venta.class);
		List<Venta> resultado = (List<Venta>) q.getResultList();
		em.close();
		return resultado;
	}
	
	/**
	 * 
	 * @param cliente Este método nos limitará los resultados con un límite
	 * @return
	 */
	
	public List<Venta> findAllLimited (int limit, int offset) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		Query q = em.createQuery("SELECT c FROM Venta c", Venta.class);
		q.setMaxResults(limit);
		q.setFirstResult(offset);
		List<Venta> resultado = (List<Venta>) q.getResultList();
		em.close();
		return resultado;
	}
	
	/**
	 * 
	 * @param cliente
	 * @return Este método nos devuelve un entero con la cantidad total de registros
	 */
	
	public int numRegistros() {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		Query q = em.createNativeQuery("SELECT count(*) FROM Venta");
		Long cantidad = (Long) q.getSingleResult();
		em.close();
		return cantidad.intValue();
		
	}
	
	public static String toString (Venta venta) {
		return venta.getId() + " " + venta.getFecha() + " - " + venta.getPrecioVenta() + " " + venta.getCliente()
		+ " " + venta.getCoche() + " " + venta.getConcesionario();
	}
}
