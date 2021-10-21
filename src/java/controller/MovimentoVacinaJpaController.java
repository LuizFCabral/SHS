package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Vacina;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.MovimentoVacina;

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
            Vacina vacina = movimentoVacina.getVacina();
            if (vacina != null) {
                vacina = em.getReference(vacina.getClass(), vacina.getCodigo());
                movimentoVacina.setVacina(vacina);
            }
            em.persist(movimentoVacina);
            if (vacina != null) {
                vacina.setMovimentoVacina(movimentoVacina);
                vacina = em.merge(vacina);
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
            Vacina vacinaOld = persistentMovimentoVacina.getVacina();
            Vacina vacinaNew = movimentoVacina.getVacina();
            List<String> illegalOrphanMessages = null;
            if (vacinaNew != null && !vacinaNew.equals(vacinaOld)) {
                MovimentoVacina oldMovimentoVacinaOfVacina = vacinaNew.getMovimentoVacina();
                if (oldMovimentoVacinaOfVacina != null) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("The Vacina " + vacinaNew + " already has an item of type MovimentoVacina whose vacina column cannot be null. Please make another selection for the vacina field.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (vacinaNew != null) {
                vacinaNew = em.getReference(vacinaNew.getClass(), vacinaNew.getCodigo());
                movimentoVacina.setVacina(vacinaNew);
            }
            movimentoVacina = em.merge(movimentoVacina);
            if (vacinaOld != null && !vacinaOld.equals(vacinaNew)) {
                vacinaOld.setMovimentoVacina(null);
                vacinaOld = em.merge(vacinaOld);
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
            Vacina vacina = movimentoVacina.getVacina();
            if (vacina != null) {
                vacina.setMovimentoVacina(null);
                vacina = em.merge(vacina);
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
