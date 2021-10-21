/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.UsuarioApl;

/**
 *
 * @author Pedro
 */
public class UsuarioAplJpaController implements Serializable {

    public UsuarioAplJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(UsuarioApl usuarioApl) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(usuarioApl);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(UsuarioApl usuarioApl) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            usuarioApl = em.merge(usuarioApl);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = usuarioApl.getCodigo();
                if (findUsuarioApl(id) == null) {
                    throw new NonexistentEntityException("The usuarioApl with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(Integer id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            UsuarioApl usuarioApl;
            try {
                usuarioApl = em.getReference(UsuarioApl.class, id);
                usuarioApl.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The usuarioApl with id " + id + " no longer exists.", enfe);
            }
            em.remove(usuarioApl);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<UsuarioApl> findUsuarioAplEntities() {
        return findUsuarioAplEntities(true, -1, -1);
    }

    public List<UsuarioApl> findUsuarioAplEntities(int maxResults, int firstResult) {
        return findUsuarioAplEntities(false, maxResults, firstResult);
    }

    private List<UsuarioApl> findUsuarioAplEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(UsuarioApl.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public UsuarioApl findUsuarioApl(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(UsuarioApl.class, id);
        } finally {
            em.close();
        }
    }

    public int getUsuarioAplCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<UsuarioApl> rt = cq.from(UsuarioApl.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
