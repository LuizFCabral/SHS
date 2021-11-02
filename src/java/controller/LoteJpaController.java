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
import model.Vacina;
import model.Vacinacao;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Lote;
import model.MovimentoVacina;

/**
 *
 * @author Pedro
 */
public class LoteJpaController implements Serializable {

    public LoteJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Lote lote) {
        if (lote.getVacinacaoList() == null) {
            lote.setVacinacaoList(new ArrayList<Vacinacao>());
        }
        if (lote.getMovimentoVacinaList() == null) {
            lote.setMovimentoVacinaList(new ArrayList<MovimentoVacina>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Vacina codigoVacina = lote.getCodigoVacina();
            if (codigoVacina != null) {
                codigoVacina = em.getReference(codigoVacina.getClass(), codigoVacina.getCodigo());
                lote.setCodigoVacina(codigoVacina);
            }
            List<Vacinacao> attachedVacinacaoList = new ArrayList<Vacinacao>();
            for (Vacinacao vacinacaoListVacinacaoToAttach : lote.getVacinacaoList()) {
                vacinacaoListVacinacaoToAttach = em.getReference(vacinacaoListVacinacaoToAttach.getClass(), vacinacaoListVacinacaoToAttach.getCodigo());
                attachedVacinacaoList.add(vacinacaoListVacinacaoToAttach);
            }
            lote.setVacinacaoList(attachedVacinacaoList);
            List<MovimentoVacina> attachedMovimentoVacinaList = new ArrayList<MovimentoVacina>();
            for (MovimentoVacina movimentoVacinaListMovimentoVacinaToAttach : lote.getMovimentoVacinaList()) {
                movimentoVacinaListMovimentoVacinaToAttach = em.getReference(movimentoVacinaListMovimentoVacinaToAttach.getClass(), movimentoVacinaListMovimentoVacinaToAttach.getCodigo());
                attachedMovimentoVacinaList.add(movimentoVacinaListMovimentoVacinaToAttach);
            }
            lote.setMovimentoVacinaList(attachedMovimentoVacinaList);
            em.persist(lote);
            if (codigoVacina != null) {
                codigoVacina.getLoteList().add(lote);
                codigoVacina = em.merge(codigoVacina);
            }
            for (Vacinacao vacinacaoListVacinacao : lote.getVacinacaoList()) {
                Lote oldCodigoLoteOfVacinacaoListVacinacao = vacinacaoListVacinacao.getCodigoLote();
                vacinacaoListVacinacao.setCodigoLote(lote);
                vacinacaoListVacinacao = em.merge(vacinacaoListVacinacao);
                if (oldCodigoLoteOfVacinacaoListVacinacao != null) {
                    oldCodigoLoteOfVacinacaoListVacinacao.getVacinacaoList().remove(vacinacaoListVacinacao);
                    oldCodigoLoteOfVacinacaoListVacinacao = em.merge(oldCodigoLoteOfVacinacaoListVacinacao);
                }
            }
            for (MovimentoVacina movimentoVacinaListMovimentoVacina : lote.getMovimentoVacinaList()) {
                Lote oldCodigoLoteOfMovimentoVacinaListMovimentoVacina = movimentoVacinaListMovimentoVacina.getCodigoLote();
                movimentoVacinaListMovimentoVacina.setCodigoLote(lote);
                movimentoVacinaListMovimentoVacina = em.merge(movimentoVacinaListMovimentoVacina);
                if (oldCodigoLoteOfMovimentoVacinaListMovimentoVacina != null) {
                    oldCodigoLoteOfMovimentoVacinaListMovimentoVacina.getMovimentoVacinaList().remove(movimentoVacinaListMovimentoVacina);
                    oldCodigoLoteOfMovimentoVacinaListMovimentoVacina = em.merge(oldCodigoLoteOfMovimentoVacinaListMovimentoVacina);
                }
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Lote lote) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Lote persistentLote = em.find(Lote.class, lote.getCodigo());
            Vacina codigoVacinaOld = persistentLote.getCodigoVacina();
            Vacina codigoVacinaNew = lote.getCodigoVacina();
            List<Vacinacao> vacinacaoListOld = persistentLote.getVacinacaoList();
            List<Vacinacao> vacinacaoListNew = lote.getVacinacaoList();
            List<MovimentoVacina> movimentoVacinaListOld = persistentLote.getMovimentoVacinaList();
            List<MovimentoVacina> movimentoVacinaListNew = lote.getMovimentoVacinaList();
            if (codigoVacinaNew != null) {
                codigoVacinaNew = em.getReference(codigoVacinaNew.getClass(), codigoVacinaNew.getCodigo());
                lote.setCodigoVacina(codigoVacinaNew);
            }
            List<Vacinacao> attachedVacinacaoListNew = new ArrayList<Vacinacao>();
            for (Vacinacao vacinacaoListNewVacinacaoToAttach : vacinacaoListNew) {
                vacinacaoListNewVacinacaoToAttach = em.getReference(vacinacaoListNewVacinacaoToAttach.getClass(), vacinacaoListNewVacinacaoToAttach.getCodigo());
                attachedVacinacaoListNew.add(vacinacaoListNewVacinacaoToAttach);
            }
            vacinacaoListNew = attachedVacinacaoListNew;
            lote.setVacinacaoList(vacinacaoListNew);
            List<MovimentoVacina> attachedMovimentoVacinaListNew = new ArrayList<MovimentoVacina>();
            for (MovimentoVacina movimentoVacinaListNewMovimentoVacinaToAttach : movimentoVacinaListNew) {
                movimentoVacinaListNewMovimentoVacinaToAttach = em.getReference(movimentoVacinaListNewMovimentoVacinaToAttach.getClass(), movimentoVacinaListNewMovimentoVacinaToAttach.getCodigo());
                attachedMovimentoVacinaListNew.add(movimentoVacinaListNewMovimentoVacinaToAttach);
            }
            movimentoVacinaListNew = attachedMovimentoVacinaListNew;
            lote.setMovimentoVacinaList(movimentoVacinaListNew);
            lote = em.merge(lote);
            if (codigoVacinaOld != null && !codigoVacinaOld.equals(codigoVacinaNew)) {
                codigoVacinaOld.getLoteList().remove(lote);
                codigoVacinaOld = em.merge(codigoVacinaOld);
            }
            if (codigoVacinaNew != null && !codigoVacinaNew.equals(codigoVacinaOld)) {
                codigoVacinaNew.getLoteList().add(lote);
                codigoVacinaNew = em.merge(codigoVacinaNew);
            }
            for (Vacinacao vacinacaoListOldVacinacao : vacinacaoListOld) {
                if (!vacinacaoListNew.contains(vacinacaoListOldVacinacao)) {
                    vacinacaoListOldVacinacao.setCodigoLote(null);
                    vacinacaoListOldVacinacao = em.merge(vacinacaoListOldVacinacao);
                }
            }
            for (Vacinacao vacinacaoListNewVacinacao : vacinacaoListNew) {
                if (!vacinacaoListOld.contains(vacinacaoListNewVacinacao)) {
                    Lote oldCodigoLoteOfVacinacaoListNewVacinacao = vacinacaoListNewVacinacao.getCodigoLote();
                    vacinacaoListNewVacinacao.setCodigoLote(lote);
                    vacinacaoListNewVacinacao = em.merge(vacinacaoListNewVacinacao);
                    if (oldCodigoLoteOfVacinacaoListNewVacinacao != null && !oldCodigoLoteOfVacinacaoListNewVacinacao.equals(lote)) {
                        oldCodigoLoteOfVacinacaoListNewVacinacao.getVacinacaoList().remove(vacinacaoListNewVacinacao);
                        oldCodigoLoteOfVacinacaoListNewVacinacao = em.merge(oldCodigoLoteOfVacinacaoListNewVacinacao);
                    }
                }
            }
            for (MovimentoVacina movimentoVacinaListOldMovimentoVacina : movimentoVacinaListOld) {
                if (!movimentoVacinaListNew.contains(movimentoVacinaListOldMovimentoVacina)) {
                    movimentoVacinaListOldMovimentoVacina.setCodigoLote(null);
                    movimentoVacinaListOldMovimentoVacina = em.merge(movimentoVacinaListOldMovimentoVacina);
                }
            }
            for (MovimentoVacina movimentoVacinaListNewMovimentoVacina : movimentoVacinaListNew) {
                if (!movimentoVacinaListOld.contains(movimentoVacinaListNewMovimentoVacina)) {
                    Lote oldCodigoLoteOfMovimentoVacinaListNewMovimentoVacina = movimentoVacinaListNewMovimentoVacina.getCodigoLote();
                    movimentoVacinaListNewMovimentoVacina.setCodigoLote(lote);
                    movimentoVacinaListNewMovimentoVacina = em.merge(movimentoVacinaListNewMovimentoVacina);
                    if (oldCodigoLoteOfMovimentoVacinaListNewMovimentoVacina != null && !oldCodigoLoteOfMovimentoVacinaListNewMovimentoVacina.equals(lote)) {
                        oldCodigoLoteOfMovimentoVacinaListNewMovimentoVacina.getMovimentoVacinaList().remove(movimentoVacinaListNewMovimentoVacina);
                        oldCodigoLoteOfMovimentoVacinaListNewMovimentoVacina = em.merge(oldCodigoLoteOfMovimentoVacinaListNewMovimentoVacina);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = lote.getCodigo();
                if (findLote(id) == null) {
                    throw new NonexistentEntityException("The lote with id " + id + " no longer exists.");
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
            Lote lote;
            try {
                lote = em.getReference(Lote.class, id);
                lote.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The lote with id " + id + " no longer exists.", enfe);
            }
            Vacina codigoVacina = lote.getCodigoVacina();
            if (codigoVacina != null) {
                codigoVacina.getLoteList().remove(lote);
                codigoVacina = em.merge(codigoVacina);
            }
            List<Vacinacao> vacinacaoList = lote.getVacinacaoList();
            for (Vacinacao vacinacaoListVacinacao : vacinacaoList) {
                vacinacaoListVacinacao.setCodigoLote(null);
                vacinacaoListVacinacao = em.merge(vacinacaoListVacinacao);
            }
            List<MovimentoVacina> movimentoVacinaList = lote.getMovimentoVacinaList();
            for (MovimentoVacina movimentoVacinaListMovimentoVacina : movimentoVacinaList) {
                movimentoVacinaListMovimentoVacina.setCodigoLote(null);
                movimentoVacinaListMovimentoVacina = em.merge(movimentoVacinaListMovimentoVacina);
            }
            em.remove(lote);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Lote> findLoteEntities() {
        return findLoteEntities(true, -1, -1);
    }

    public List<Lote> findLoteEntities(int maxResults, int firstResult) {
        return findLoteEntities(false, maxResults, firstResult);
    }

    private List<Lote> findLoteEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Lote.class));
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

    public Lote findLote(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Lote.class, id);
        } finally {
            em.close();
        }
    }

    public int getLoteCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Lote> rt = cq.from(Lote.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
