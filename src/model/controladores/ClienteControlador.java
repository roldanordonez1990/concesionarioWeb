package model.controladores;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.Query;

import model.Cliente;
import model.Controlador;
import model.Fabricante;

public class ClienteControlador extends Controlador {

	private static ClienteControlador controlador = null;

	public ClienteControlador(Class entidadControlada, String unidadPersistencia) {
		super(entidadControlada, unidadPersistencia);
		// TODO Auto-generated constructor stub
	}

	public ClienteControlador() {
		super(Cliente.class, "VentaDeCoches");
	}

	public static ClienteControlador getControlador() {
		if (controlador == null) {
			controlador = new ClienteControlador();
		}
		return controlador;
	}

	/**
	 *  
	 */
	public Cliente find(int id) {
		return (Cliente) super.find(id);
	}

	/**
	 * 
	 * @return
	 */
	public Cliente findFirst() {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Cliente c order by c.id", Cliente.class);
			Cliente resultado = (Cliente) q.setMaxResults(1).getSingleResult();
			// esto es una consulta en PSQL, con una consulta SQL de por medio
			em.close();
			return resultado;
		} catch (NoResultException nrEx) {
			return null;
		}
	}

	/**
	 * 
	 * @return
	 */
	public Cliente findLast() {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Cliente c order by c.id desc", Cliente.class);
			Cliente resultado = (Cliente) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		} catch (NoResultException nrEx) {
			return null;
		}
	}

	/**
	 * 
	 * @return
	 */
	public Cliente findNext(Cliente c) {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Cliente c where c.id > :idActual order by c.id", Cliente.class);
			q.setParameter("idActual", c.getId());
			Cliente resultado = (Cliente) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		} catch (NoResultException nrEx) {
			return null;
		}
	}

	/**
	 * 
	 * @return
	 */
	public Cliente findPrevious(Cliente c) {
		try {
			EntityManager em = getEntityManagerFactory().createEntityManager();
			Query q = em.createQuery("SELECT c FROM Cliente c where c.id < :idActual order by c.id desc",
					Cliente.class);
			q.setParameter("idActual", c.getId());
			Cliente resultado = (Cliente) q.setMaxResults(1).getSingleResult();
			em.close();
			return resultado;
		} catch (NoResultException nrEx) {
			return null;
		}
	}

	/**
	 * 
	 * @param coche
	 * @return
	 */
	public boolean exists(Cliente coche) {
		EntityManager em = getEntityManagerFactory().createEntityManager();

		boolean ok = true;
		try {
			Query q = em.createNativeQuery("SELECT * FROM tutorialjavacoches.coche where id = ?", Cliente.class);
			q.setParameter(1, coche.getId());
			coche = (Cliente) q.getSingleResult();
		} catch (NoResultException ex) {
			ok = false;
		}
		em.close();
		return ok;
	}

	public List<Cliente> findAll() {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		Query q = em.createQuery("SELECT c FROM Cliente c", Cliente.class);
		List<Cliente> resultado = (List<Cliente>) q.getResultList();
		em.close();
		return resultado;
	}

	public static String toString(Cliente cliente) {
		return cliente.getNombre() + " " + cliente.getApellidos() + " " + cliente.getDniNie() + " "
				+ cliente.getLocalidad() + " " + cliente.getFechaNac() + " " + cliente.getActivo();
	}

}
