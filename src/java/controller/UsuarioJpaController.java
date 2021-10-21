/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Agenda;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Usuario;

/**
 *
 * @author Pedro
 */
public class UsuarioJpaController implements Serializable {

    public UsuarioJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Usuario usuario) {
        if (usuario.getAgendaList() == null) {
            usuario.setAgendaList(new ArrayList<Agenda>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            List<Agenda> attachedAgendaList = new ArrayList<Agenda>();
            for (Agenda agendaListAgendaToAttach : usuario.getAgendaList()) {
                agendaListAgendaToAttach = em.getReference(agendaListAgendaToAttach.getClass(), agendaListAgendaToAttach.getCodigo());
                attachedAgendaList.add(agendaListAgendaToAttach);
            }
            usuario.setAgendaList(attachedAgendaList);
            em.persist(usuario);
            for (Agenda agendaListAgenda : usuario.getAgendaList()) {
                Usuario oldCodigoUsuarioOfAgendaListAgenda = agendaListAgenda.getCodigoUsuario();
                agendaListAgenda.setCodigoUsuario(usuario);
                agendaListAgenda = em.merge(agendaListAgenda);
                if (oldCodigoUsuarioOfAgendaListAgenda != null) {
                    oldCodigoUsuarioOfAgendaListAgenda.getAgendaList().remove(agendaListAgenda);
                    oldCodigoUsuarioOfAgendaListAgenda = em.merge(oldCodigoUsuarioOfAgendaListAgenda);
                }
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Usuario usuario) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Usuario persistentUsuario = em.find(Usuario.class, usuario.getCodigo());
            List<Agenda> agendaListOld = persistentUsuario.getAgendaList();
            List<Agenda> agendaListNew = usuario.getAgendaList();
            List<Agenda> attachedAgendaListNew = new ArrayList<Agenda>();
            for (Agenda agendaListNewAgendaToAttach : agendaListNew) {
                agendaListNewAgendaToAttach = em.getReference(agendaListNewAgendaToAttach.getClass(), agendaListNewAgendaToAttach.getCodigo());
                attachedAgendaListNew.add(agendaListNewAgendaToAttach);
            }
            agendaListNew = attachedAgendaListNew;
            usuario.setAgendaList(agendaListNew);
            usuario = em.merge(usuario);
            for (Agenda agendaListOldAgenda : agendaListOld) {
                if (!agendaListNew.contains(agendaListOldAgenda)) {
                    agendaListOldAgenda.setCodigoUsuario(null);
                    agendaListOldAgenda = em.merge(agendaListOldAgenda);
                }
            }
            for (Agenda agendaListNewAgenda : agendaListNew) {
                if (!agendaListOld.contains(agendaListNewAgenda)) {
                    Usuario oldCodigoUsuarioOfAgendaListNewAgenda = agendaListNewAgenda.getCodigoUsuario();
                    agendaListNewAgenda.setCodigoUsuario(usuario);
                    agendaListNewAgenda = em.merge(agendaListNewAgenda);
                    if (oldCodigoUsuarioOfAgendaListNewAgenda != null && !oldCodigoUsuarioOfAgendaListNewAgenda.equals(usuario)) {
                        oldCodigoUsuarioOfAgendaListNewAgenda.getAgendaList().remove(agendaListNewAgenda);
                        oldCodigoUsuarioOfAgendaListNewAgenda = em.merge(oldCodigoUsuarioOfAgendaListNewAgenda);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = usuario.getCodigo();
                if (findUsuario(id) == null) {
                    throw new NonexistentEntityException("The usuario with id " + id + " no longer exists.");
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
            Usuario usuario;
            try {
                usuario = em.getReference(Usuario.class, id);
                usuario.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The usuario with id " + id + " no longer exists.", enfe);
            }
            List<Agenda> agendaList = usuario.getAgendaList();
            for (Agenda agendaListAgenda : agendaList) {
                agendaListAgenda.setCodigoUsuario(null);
                agendaListAgenda = em.merge(agendaListAgenda);
            }
            em.remove(usuario);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Usuario> findUsuarioEntities() {
        return findUsuarioEntities(true, -1, -1);
    }

    public List<Usuario> findUsuarioEntities(int maxResults, int firstResult) {
        return findUsuarioEntities(false, maxResults, firstResult);
    }

    private List<Usuario> findUsuarioEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Usuario.class));
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

    public Usuario findUsuario(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Usuario.class, id);
        } finally {
            em.close();
        }
    }

    public int getUsuarioCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Usuario> rt = cq.from(Usuario.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
