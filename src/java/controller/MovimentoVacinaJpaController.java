package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Lote;
import model.MovimentoVacina;
import model.Vacina;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.MovimentoVacina;

/**
 *
 * @author vinif
 */
public class MovimentoVacinaJpaController implements Serializable {

    public MovimentoVacinaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(MovimentoVacina movimentoVacina) throws IllegalOrphanException {
        List<String> illegalOrphanMessages = null;
        Vacina vacinaOrphanCheck = movimentoVacina.getVacina();
        if (vacinaOrphanCheck != null) {
            MovimentoVacina oldMovimentoVacinaOfVacina = vacinaOrphanCheck.getMovimentoVacina();
            if (oldMovimentoVacinaOfVacina != null) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("The Vacina " + vacinaOrphanCheck + " already has an item of type MovimentoVacina whose vacina column cannot be null. Please make another selection for the vacina field.");
            }
        }
        if (illegalOrphanMessages != null) {
            throw new IllegalOrphanException(illegalOrphanMessages);
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Lote codigoLote = movimentoVacina.getCodigoLote();
            if (codigoLote != null) {
                codigoLote = em.getReference(codigoLote.getClass(), codigoLote.getCodigo());
                movimentoVacina.setCodigoLote(codigoLote);
            }
            Vacina codigoVacina = movimentoVacina.getCodigoVacina();
            if (codigoVacina != null) {
                codigoVacina = em.getReference(codigoVacina.getClass(), codigoVacina.getCodigo());
                movimentoVacina.setCodigoVacina(codigoVacina);
            }
            em.persist(movimentoVacina);
            if (codigoLote != null) {
                codigoLote.getMovimentoVacinaList().add(movimentoVacina);
                codigoLote = em.merge(codigoLote);
            }
            if (codigoVacina != null) {
                codigoVacina.getMovimentoVacinaList().add(movimentoVacina);
                codigoVacina = em.merge(codigoVacina);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(MovimentoVacina movimentoVacina) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            MovimentoVacina persistentMovimentoVacina = em.find(MovimentoVacina.class, movimentoVacina.getCodigo());
            Lote codigoLoteOld = persistentMovimentoVacina.getCodigoLote();
            Lote codigoLoteNew = movimentoVacina.getCodigoLote();
            Vacina codigoVacinaOld = persistentMovimentoVacina.getCodigoVacina();
            Vacina codigoVacinaNew = movimentoVacina.getCodigoVacina();
            if (codigoLoteNew != null) {
                codigoLoteNew = em.getReference(codigoLoteNew.getClass(), codigoLoteNew.getCodigo());
                movimentoVacina.setCodigoLote(codigoLoteNew);
            }
            if (codigoVacinaNew != null) {
                codigoVacinaNew = em.getReference(codigoVacinaNew.getClass(), codigoVacinaNew.getCodigo());
                movimentoVacina.setCodigoVacina(codigoVacinaNew);
            }
            movimentoVacina = em.merge(movimentoVacina);
            if (codigoLoteOld != null && !codigoLoteOld.equals(codigoLoteNew)) {
                codigoLoteOld.getMovimentoVacinaList().remove(movimentoVacina);
                codigoLoteOld = em.merge(codigoLoteOld);
            }
            if (codigoLoteNew != null && !codigoLoteNew.equals(codigoLoteOld)) {
                codigoLoteNew.getMovimentoVacinaList().add(movimentoVacina);
                codigoLoteNew = em.merge(codigoLoteNew);
            }
            if (codigoVacinaOld != null && !codigoVacinaOld.equals(codigoVacinaNew)) {
                codigoVacinaOld.getMovimentoVacinaList().remove(movimentoVacina);
                codigoVacinaOld = em.merge(codigoVacinaOld);
            }
            if (vacinaNew != null && !vacinaNew.equals(vacinaOld)) {
                vacinaNew.setMovimentoVacina(movimentoVacina);
                vacinaNew = em.merge(vacinaNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = movimentoVacina.getCodigo();
                if (findMovimentoVacina(id) == null) {
                    throw new NonexistentEntityException("The movimentoVacina with id " + id + " no longer exists.");
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
            MovimentoVacina movimentoVacina;
            try {
                movimentoVacina = em.getReference(MovimentoVacina.class, id);
                movimentoVacina.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The movimentoVacina with id " + id + " no longer exists.", enfe);
            }
            Lote codigoLote = movimentoVacina.getCodigoLote();
            if (codigoLote != null) {
                codigoLote.getMovimentoVacinaList().remove(movimentoVacina);
                codigoLote = em.merge(codigoLote);
            }
            Vacina codigoVacina = movimentoVacina.getCodigoVacina();
            if (codigoVacina != null) {
                codigoVacina.getMovimentoVacinaList().remove(movimentoVacina);
                codigoVacina = em.merge(codigoVacina);
            }
            em.remove(movimentoVacina);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<MovimentoVacina> findMovimentoVacinaEntities() {
        return findMovimentoVacinaEntities(true, -1, -1);
    }

    public List<MovimentoVacina> findMovimentoVacinaEntities(int maxResults, int firstResult) {
        return findMovimentoVacinaEntities(false, maxResults, firstResult);
    }

    private List<MovimentoVacina> findMovimentoVacinaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(MovimentoVacina.class));
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

    public MovimentoVacina findMovimentoVacina(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(MovimentoVacina.class, id);
        } finally {
            em.close();
        }
    }

    public int getMovimentoVacinaCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<MovimentoVacina> rt = cq.from(MovimentoVacina.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
