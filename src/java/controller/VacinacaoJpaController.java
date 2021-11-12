/*
VACINACAO JPA CONTROLLER ==========================================================
Esta classe serve como agrupamento das operações básicas de CRUD para a classe 
Vacinacao. Para melhor explicação sobre o que é uma classe JPA CONTROLLER, cf. 
AgendaJpaController, onde isso está explicado.
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
import model.Agenda;
import model.Lote;
import model.Usuario;
import model.UsuarioApl;
import model.Vacinacao;

public class VacinacaoJpaController implements Serializable {

    public VacinacaoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Vacinacao vacinacao) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Agenda codigoAgenda = vacinacao.getCodigoAgenda();
            if (codigoAgenda != null) {
                codigoAgenda = em.getReference(codigoAgenda.getClass(), codigoAgenda.getCodigo());
                vacinacao.setCodigoAgenda(codigoAgenda);
            }
            Lote codigoLote = vacinacao.getCodigoLote();
            if (codigoLote != null) {
                codigoLote = em.getReference(codigoLote.getClass(), codigoLote.getCodigo());
                vacinacao.setCodigoLote(codigoLote);
            }
            Usuario codigoUsuario = vacinacao.getCodigoUsuario();
            if (codigoUsuario != null) {
                codigoUsuario = em.getReference(codigoUsuario.getClass(), codigoUsuario.getCodigo());
                vacinacao.setCodigoUsuario(codigoUsuario);
            }
            UsuarioApl codigoUsuarioApl = vacinacao.getCodigoUsuarioApl();
            if (codigoUsuarioApl != null) {
                codigoUsuarioApl = em.getReference(codigoUsuarioApl.getClass(), codigoUsuarioApl.getCodigo());
                vacinacao.setCodigoUsuarioApl(codigoUsuarioApl);
            }
            em.persist(vacinacao);
            if (codigoAgenda != null) {
                codigoAgenda.getVacinacaoList().add(vacinacao);
                codigoAgenda = em.merge(codigoAgenda);
            }
            if (codigoLote != null) {
                codigoLote.getVacinacaoList().add(vacinacao);
                codigoLote = em.merge(codigoLote);
            }
            if (codigoUsuario != null) {
                codigoUsuario.getVacinacaoList().add(vacinacao);
                codigoUsuario = em.merge(codigoUsuario);
            }
            if (codigoUsuarioApl != null) {
                codigoUsuarioApl.getVacinacaoList().add(vacinacao);
                codigoUsuarioApl = em.merge(codigoUsuarioApl);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Vacinacao vacinacao) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Vacinacao persistentVacinacao = em.find(Vacinacao.class, vacinacao.getCodigo());
            Agenda codigoAgendaOld = persistentVacinacao.getCodigoAgenda();
            Agenda codigoAgendaNew = vacinacao.getCodigoAgenda();
            Lote codigoLoteOld = persistentVacinacao.getCodigoLote();
            Lote codigoLoteNew = vacinacao.getCodigoLote();
            Usuario codigoUsuarioOld = persistentVacinacao.getCodigoUsuario();
            Usuario codigoUsuarioNew = vacinacao.getCodigoUsuario();
            UsuarioApl codigoUsuarioAplOld = persistentVacinacao.getCodigoUsuarioApl();
            UsuarioApl codigoUsuarioAplNew = vacinacao.getCodigoUsuarioApl();
            if (codigoAgendaNew != null) {
                codigoAgendaNew = em.getReference(codigoAgendaNew.getClass(), codigoAgendaNew.getCodigo());
                vacinacao.setCodigoAgenda(codigoAgendaNew);
            }
            if (codigoLoteNew != null) {
                codigoLoteNew = em.getReference(codigoLoteNew.getClass(), codigoLoteNew.getCodigo());
                vacinacao.setCodigoLote(codigoLoteNew);
            }
            if (codigoUsuarioNew != null) {
                codigoUsuarioNew = em.getReference(codigoUsuarioNew.getClass(), codigoUsuarioNew.getCodigo());
                vacinacao.setCodigoUsuario(codigoUsuarioNew);
            }
            if (codigoUsuarioAplNew != null) {
                codigoUsuarioAplNew = em.getReference(codigoUsuarioAplNew.getClass(), codigoUsuarioAplNew.getCodigo());
                vacinacao.setCodigoUsuarioApl(codigoUsuarioAplNew);
            }
            vacinacao = em.merge(vacinacao);
            if (codigoAgendaOld != null && !codigoAgendaOld.equals(codigoAgendaNew)) {
                codigoAgendaOld.getVacinacaoList().remove(vacinacao);
                codigoAgendaOld = em.merge(codigoAgendaOld);
            }
            if (codigoAgendaNew != null && !codigoAgendaNew.equals(codigoAgendaOld)) {
                codigoAgendaNew.getVacinacaoList().add(vacinacao);
                codigoAgendaNew = em.merge(codigoAgendaNew);
            }
            if (codigoLoteOld != null && !codigoLoteOld.equals(codigoLoteNew)) {
                codigoLoteOld.getVacinacaoList().remove(vacinacao);
                codigoLoteOld = em.merge(codigoLoteOld);
            }
            if (codigoLoteNew != null && !codigoLoteNew.equals(codigoLoteOld)) {
                codigoLoteNew.getVacinacaoList().add(vacinacao);
                codigoLoteNew = em.merge(codigoLoteNew);
            }
            if (codigoUsuarioOld != null && !codigoUsuarioOld.equals(codigoUsuarioNew)) {
                codigoUsuarioOld.getVacinacaoList().remove(vacinacao);
                codigoUsuarioOld = em.merge(codigoUsuarioOld);
            }
            if (codigoUsuarioNew != null && !codigoUsuarioNew.equals(codigoUsuarioOld)) {
                codigoUsuarioNew.getVacinacaoList().add(vacinacao);
                codigoUsuarioNew = em.merge(codigoUsuarioNew);
            }
            if (codigoUsuarioAplOld != null && !codigoUsuarioAplOld.equals(codigoUsuarioAplNew)) {
                codigoUsuarioAplOld.getVacinacaoList().remove(vacinacao);
                codigoUsuarioAplOld = em.merge(codigoUsuarioAplOld);
            }
            if (codigoUsuarioAplNew != null && !codigoUsuarioAplNew.equals(codigoUsuarioAplOld)) {
                codigoUsuarioAplNew.getVacinacaoList().add(vacinacao);
                codigoUsuarioAplNew = em.merge(codigoUsuarioAplNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = vacinacao.getCodigo();
                if (findVacinacao(id) == null) {
                    throw new NonexistentEntityException("The vacinacao with id " + id + " no longer exists.");
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
            Vacinacao vacinacao;
            try {
                vacinacao = em.getReference(Vacinacao.class, id);
                vacinacao.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The vacinacao with id " + id + " no longer exists.", enfe);
            }
            Agenda codigoAgenda = vacinacao.getCodigoAgenda();
            if (codigoAgenda != null) {
                codigoAgenda.getVacinacaoList().remove(vacinacao);
                codigoAgenda = em.merge(codigoAgenda);
            }
            Lote codigoLote = vacinacao.getCodigoLote();
            if (codigoLote != null) {
                codigoLote.getVacinacaoList().remove(vacinacao);
                codigoLote = em.merge(codigoLote);
            }
            Usuario codigoUsuario = vacinacao.getCodigoUsuario();
            if (codigoUsuario != null) {
                codigoUsuario.getVacinacaoList().remove(vacinacao);
                codigoUsuario = em.merge(codigoUsuario);
            }
            UsuarioApl codigoUsuarioApl = vacinacao.getCodigoUsuarioApl();
            if (codigoUsuarioApl != null) {
                codigoUsuarioApl.getVacinacaoList().remove(vacinacao);
                codigoUsuarioApl = em.merge(codigoUsuarioApl);
            }
            em.remove(vacinacao);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Vacinacao> findVacinacaoEntities() {
        return findVacinacaoEntities(true, -1, -1);
    }

    public List<Vacinacao> findVacinacaoEntities(int maxResults, int firstResult) {
        return findVacinacaoEntities(false, maxResults, firstResult);
    }

    private List<Vacinacao> findVacinacaoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Vacinacao.class));
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

    public Vacinacao findVacinacao(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Vacinacao.class, id);
        } finally {
            em.close();
        }
    }

    public int getVacinacaoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Vacinacao> rt = cq.from(Vacinacao.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
