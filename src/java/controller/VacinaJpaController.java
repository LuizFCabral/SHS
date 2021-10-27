package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Lote;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.MovimentoVacina;
import model.Vacina;

/**
 *
 * @author vinif
 */
public class VacinaJpaController implements Serializable {

    public VacinaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Vacina vacina) {
        if (vacina.getLoteList() == null) {
            vacina.setLoteList(new ArrayList<Lote>());
        }
        if (vacina.getMovimentoVacinaList() == null) {
            vacina.setMovimentoVacinaList(new ArrayList<MovimentoVacina>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            List<Lote> attachedLoteList = new ArrayList<Lote>();
            for (Lote loteListLoteToAttach : vacina.getLoteList()) {
                loteListLoteToAttach = em.getReference(loteListLoteToAttach.getClass(), loteListLoteToAttach.getCodigo());
                attachedLoteList.add(loteListLoteToAttach);
            }
            vacina.setLoteList(attachedLoteList);
            List<MovimentoVacina> attachedMovimentoVacinaList = new ArrayList<MovimentoVacina>();
            for (MovimentoVacina movimentoVacinaListMovimentoVacinaToAttach : vacina.getMovimentoVacinaList()) {
                movimentoVacinaListMovimentoVacinaToAttach = em.getReference(movimentoVacinaListMovimentoVacinaToAttach.getClass(), movimentoVacinaListMovimentoVacinaToAttach.getCodigo());
                attachedMovimentoVacinaList.add(movimentoVacinaListMovimentoVacinaToAttach);
            }
            em.persist(vacina);
            for (Lote loteListLote : vacina.getLoteList()) {
                Vacina oldCodigoVacinaOfLoteListLote = loteListLote.getCodigoVacina();
                loteListLote.setCodigoVacina(vacina);
                loteListLote = em.merge(loteListLote);
                if (oldCodigoVacinaOfLoteListLote != null) {
                    oldCodigoVacinaOfLoteListLote.getLoteList().remove(loteListLote);
                    oldCodigoVacinaOfLoteListLote = em.merge(oldCodigoVacinaOfLoteListLote);
                }
            }
            for (MovimentoVacina movimentoVacinaListMovimentoVacina : vacina.getMovimentoVacinaList()) {
                Vacina oldCodigoVacinaOfMovimentoVacinaListMovimentoVacina = movimentoVacinaListMovimentoVacina.getCodigoVacina();
                movimentoVacinaListMovimentoVacina.setCodigoVacina(vacina);
                movimentoVacinaListMovimentoVacina = em.merge(movimentoVacinaListMovimentoVacina);
                if (oldCodigoVacinaOfMovimentoVacinaListMovimentoVacina != null) {
                    oldCodigoVacinaOfMovimentoVacinaListMovimentoVacina.getMovimentoVacinaList().remove(movimentoVacinaListMovimentoVacina);
                    oldCodigoVacinaOfMovimentoVacinaListMovimentoVacina = em.merge(oldCodigoVacinaOfMovimentoVacinaListMovimentoVacina);
                }
                movimentoVacina.setVacina(vacina);
                movimentoVacina = em.merge(movimentoVacina);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Vacina vacina) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Vacina persistentVacina = em.find(Vacina.class, vacina.getCodigo());
            List<Lote> loteListOld = persistentVacina.getLoteList();
            List<Lote> loteListNew = vacina.getLoteList();
            List<MovimentoVacina> movimentoVacinaListOld = persistentVacina.getMovimentoVacinaList();
            List<MovimentoVacina> movimentoVacinaListNew = vacina.getMovimentoVacinaList();
            List<Lote> attachedLoteListNew = new ArrayList<Lote>();
            for (Lote loteListNewLoteToAttach : loteListNew) {
                loteListNewLoteToAttach = em.getReference(loteListNewLoteToAttach.getClass(), loteListNewLoteToAttach.getCodigo());
                attachedLoteListNew.add(loteListNewLoteToAttach);
            }
            loteListNew = attachedLoteListNew;
            vacina.setLoteList(loteListNew);
            List<MovimentoVacina> attachedMovimentoVacinaListNew = new ArrayList<MovimentoVacina>();
            for (MovimentoVacina movimentoVacinaListNewMovimentoVacinaToAttach : movimentoVacinaListNew) {
                movimentoVacinaListNewMovimentoVacinaToAttach = em.getReference(movimentoVacinaListNewMovimentoVacinaToAttach.getClass(), movimentoVacinaListNewMovimentoVacinaToAttach.getCodigo());
                attachedMovimentoVacinaListNew.add(movimentoVacinaListNewMovimentoVacinaToAttach);
            }
            movimentoVacinaListNew = attachedMovimentoVacinaListNew;
            vacina.setMovimentoVacinaList(movimentoVacinaListNew);
            vacina = em.merge(vacina);
            for (Lote loteListOldLote : loteListOld) {
                if (!loteListNew.contains(loteListOldLote)) {
                    loteListOldLote.setCodigoVacina(null);
                    loteListOldLote = em.merge(loteListOldLote);
                }
            }
            for (Lote loteListNewLote : loteListNew) {
                if (!loteListOld.contains(loteListNewLote)) {
                    Vacina oldCodigoVacinaOfLoteListNewLote = loteListNewLote.getCodigoVacina();
                    loteListNewLote.setCodigoVacina(vacina);
                    loteListNewLote = em.merge(loteListNewLote);
                    if (oldCodigoVacinaOfLoteListNewLote != null && !oldCodigoVacinaOfLoteListNewLote.equals(vacina)) {
                        oldCodigoVacinaOfLoteListNewLote.getLoteList().remove(loteListNewLote);
                        oldCodigoVacinaOfLoteListNewLote = em.merge(oldCodigoVacinaOfLoteListNewLote);
                    }
                }
            }
            for (MovimentoVacina movimentoVacinaListOldMovimentoVacina : movimentoVacinaListOld) {
                if (!movimentoVacinaListNew.contains(movimentoVacinaListOldMovimentoVacina)) {
                    movimentoVacinaListOldMovimentoVacina.setCodigoVacina(null);
                    movimentoVacinaListOldMovimentoVacina = em.merge(movimentoVacinaListOldMovimentoVacina);
                }
                illegalOrphanMessages.add("You must retain MovimentoVacina " + movimentoVacinaOld + " since its vacina field is not nullable.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (movimentoVacinaNew != null) {
                movimentoVacinaNew = em.getReference(movimentoVacinaNew.getClass(), movimentoVacinaNew.getCodigo());
                vacina.setMovimentoVacina(movimentoVacinaNew);
            }
            vacina = em.merge(vacina);
            if (movimentoVacinaNew != null && !movimentoVacinaNew.equals(movimentoVacinaOld)) {
                Vacina oldVacinaOfMovimentoVacina = movimentoVacinaNew.getVacina();
                if (oldVacinaOfMovimentoVacina != null) {
                    oldVacinaOfMovimentoVacina.setMovimentoVacina(null);
                    oldVacinaOfMovimentoVacina = em.merge(oldVacinaOfMovimentoVacina);
                }
                movimentoVacinaNew.setVacina(vacina);
                movimentoVacinaNew = em.merge(movimentoVacinaNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = vacina.getCodigo();
                if (findVacina(id) == null) {
                    throw new NonexistentEntityException("The vacina with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(Integer id) throws IllegalOrphanException, NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Vacina vacina;
            try {
                vacina = em.getReference(Vacina.class, id);
                vacina.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The vacina with id " + id + " no longer exists.", enfe);
            }
            List<Lote> loteList = vacina.getLoteList();
            for (Lote loteListLote : loteList) {
                loteListLote.setCodigoVacina(null);
                loteListLote = em.merge(loteListLote);
            }
            List<MovimentoVacina> movimentoVacinaList = vacina.getMovimentoVacinaList();
            for (MovimentoVacina movimentoVacinaListMovimentoVacina : movimentoVacinaList) {
                movimentoVacinaListMovimentoVacina.setCodigoVacina(null);
                movimentoVacinaListMovimentoVacina = em.merge(movimentoVacinaListMovimentoVacina);
            }
            em.remove(vacina);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Vacina> findVacinaEntities() {
        return findVacinaEntities(true, -1, -1);
    }

    public List<Vacina> findVacinaEntities(int maxResults, int firstResult) {
        return findVacinaEntities(false, maxResults, firstResult);
    }

    private List<Vacina> findVacinaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Vacina.class));
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

    public Vacina findVacina(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Vacina.class, id);
        } finally {
            em.close();
        }
    }

    public int getVacinaCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Vacina> rt = cq.from(Vacina.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
