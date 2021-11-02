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
import model.Usuario;
import model.Vacinacao;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Agenda;

/**
 *
 * @author Pedro
 */
public class AgendaJpaController implements Serializable {

    public AgendaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Agenda agenda) {
        if (agenda.getVacinacaoList() == null) {
            agenda.setVacinacaoList(new ArrayList<Vacinacao>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Usuario codigoUsuario = agenda.getCodigoUsuario();
            if (codigoUsuario != null) {
                codigoUsuario = em.getReference(codigoUsuario.getClass(), codigoUsuario.getCodigo());
                agenda.setCodigoUsuario(codigoUsuario);
            }
            List<Vacinacao> attachedVacinacaoList = new ArrayList<Vacinacao>();
            for (Vacinacao vacinacaoListVacinacaoToAttach : agenda.getVacinacaoList()) {
                vacinacaoListVacinacaoToAttach = em.getReference(vacinacaoListVacinacaoToAttach.getClass(), vacinacaoListVacinacaoToAttach.getCodigo());
                attachedVacinacaoList.add(vacinacaoListVacinacaoToAttach);
            }
            agenda.setVacinacaoList(attachedVacinacaoList);
            em.persist(agenda);
            if (codigoUsuario != null) {
                codigoUsuario.getAgendaList().add(agenda);
                codigoUsuario = em.merge(codigoUsuario);
            }
            for (Vacinacao vacinacaoListVacinacao : agenda.getVacinacaoList()) {
                Agenda oldCodigoAgendaOfVacinacaoListVacinacao = vacinacaoListVacinacao.getCodigoAgenda();
                vacinacaoListVacinacao.setCodigoAgenda(agenda);
                vacinacaoListVacinacao = em.merge(vacinacaoListVacinacao);
                if (oldCodigoAgendaOfVacinacaoListVacinacao != null) {
                    oldCodigoAgendaOfVacinacaoListVacinacao.getVacinacaoList().remove(vacinacaoListVacinacao);
                    oldCodigoAgendaOfVacinacaoListVacinacao = em.merge(oldCodigoAgendaOfVacinacaoListVacinacao);
                }
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Agenda agenda) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Agenda persistentAgenda = em.find(Agenda.class, agenda.getCodigo());
            Usuario codigoUsuarioOld = persistentAgenda.getCodigoUsuario();
            Usuario codigoUsuarioNew = agenda.getCodigoUsuario();
            List<Vacinacao> vacinacaoListOld = persistentAgenda.getVacinacaoList();
            List<Vacinacao> vacinacaoListNew = agenda.getVacinacaoList();
            if (codigoUsuarioNew != null) {
                codigoUsuarioNew = em.getReference(codigoUsuarioNew.getClass(), codigoUsuarioNew.getCodigo());
                agenda.setCodigoUsuario(codigoUsuarioNew);
            }
            List<Vacinacao> attachedVacinacaoListNew = new ArrayList<Vacinacao>();
            for (Vacinacao vacinacaoListNewVacinacaoToAttach : vacinacaoListNew) {
                vacinacaoListNewVacinacaoToAttach = em.getReference(vacinacaoListNewVacinacaoToAttach.getClass(), vacinacaoListNewVacinacaoToAttach.getCodigo());
                attachedVacinacaoListNew.add(vacinacaoListNewVacinacaoToAttach);
            }
            vacinacaoListNew = attachedVacinacaoListNew;
            agenda.setVacinacaoList(vacinacaoListNew);
            agenda = em.merge(agenda);
            if (codigoUsuarioOld != null && !codigoUsuarioOld.equals(codigoUsuarioNew)) {
                codigoUsuarioOld.getAgendaList().remove(agenda);
                codigoUsuarioOld = em.merge(codigoUsuarioOld);
            }
            if (codigoUsuarioNew != null && !codigoUsuarioNew.equals(codigoUsuarioOld)) {
                codigoUsuarioNew.getAgendaList().add(agenda);
                codigoUsuarioNew = em.merge(codigoUsuarioNew);
            }
            for (Vacinacao vacinacaoListOldVacinacao : vacinacaoListOld) {
                if (!vacinacaoListNew.contains(vacinacaoListOldVacinacao)) {
                    vacinacaoListOldVacinacao.setCodigoAgenda(null);
                    vacinacaoListOldVacinacao = em.merge(vacinacaoListOldVacinacao);
                }
            }
            for (Vacinacao vacinacaoListNewVacinacao : vacinacaoListNew) {
                if (!vacinacaoListOld.contains(vacinacaoListNewVacinacao)) {
                    Agenda oldCodigoAgendaOfVacinacaoListNewVacinacao = vacinacaoListNewVacinacao.getCodigoAgenda();
                    vacinacaoListNewVacinacao.setCodigoAgenda(agenda);
                    vacinacaoListNewVacinacao = em.merge(vacinacaoListNewVacinacao);
                    if (oldCodigoAgendaOfVacinacaoListNewVacinacao != null && !oldCodigoAgendaOfVacinacaoListNewVacinacao.equals(agenda)) {
                        oldCodigoAgendaOfVacinacaoListNewVacinacao.getVacinacaoList().remove(vacinacaoListNewVacinacao);
                        oldCodigoAgendaOfVacinacaoListNewVacinacao = em.merge(oldCodigoAgendaOfVacinacaoListNewVacinacao);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = agenda.getCodigo();
                if (findAgenda(id) == null) {
                    throw new NonexistentEntityException("The agenda with id " + id + " no longer exists.");
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
            Agenda agenda;
            try {
                agenda = em.getReference(Agenda.class, id);
                agenda.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The agenda with id " + id + " no longer exists.", enfe);
            }
            Usuario codigoUsuario = agenda.getCodigoUsuario();
            if (codigoUsuario != null) {
                codigoUsuario.getAgendaList().remove(agenda);
                codigoUsuario = em.merge(codigoUsuario);
            }
            List<Vacinacao> vacinacaoList = agenda.getVacinacaoList();
            for (Vacinacao vacinacaoListVacinacao : vacinacaoList) {
                vacinacaoListVacinacao.setCodigoAgenda(null);
                vacinacaoListVacinacao = em.merge(vacinacaoListVacinacao);
            }
            em.remove(agenda);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Agenda> findAgendaEntities() {
        return findAgendaEntities(true, -1, -1);
    }

    public List<Agenda> findAgendaEntities(int maxResults, int firstResult) {
        return findAgendaEntities(false, maxResults, firstResult);
    }

    private List<Agenda> findAgendaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Agenda.class));
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

    public Agenda findAgenda(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Agenda.class, id);
        } finally {
            em.close();
        }
    }

    public int getAgendaCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Agenda> rt = cq.from(Agenda.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
