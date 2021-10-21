package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.MovimentoVacina;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Vacina;

public class VacinaJpaController implements Serializable {

    public VacinaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Vacina vacina) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            MovimentoVacina movimentoVacina = vacina.getMovimentoVacina();
            if (movimentoVacina != null) {
                movimentoVacina = em.getReference(movimentoVacina.getClass(), movimentoVacina.getCodigo());
                vacina.setMovimentoVacina(movimentoVacina);
            }
            em.persist(vacina);
            if (movimentoVacina != null) {
                Vacina oldVacinaOfMovimentoVacina = movimentoVacina.getVacina();
                if (oldVacinaOfMovimentoVacina != null) {
                    oldVacinaOfMovimentoVacina.setMovimentoVacina(null);
                    oldVacinaOfMovimentoVacina = em.merge(oldVacinaOfMovimentoVacina);
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
            MovimentoVacina movimentoVacinaOld = persistentVacina.getMovimentoVacina();
            MovimentoVacina movimentoVacinaNew = vacina.getMovimentoVacina();
            List<String> illegalOrphanMessages = null;
            if (movimentoVacinaOld != null && !movimentoVacinaOld.equals(movimentoVacinaNew)) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
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
            List<String> illegalOrphanMessages = null;
            MovimentoVacina movimentoVacinaOrphanCheck = vacina.getMovimentoVacina();
            if (movimentoVacinaOrphanCheck != null) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Vacina (" + vacina + ") cannot be destroyed since the MovimentoVacina " + movimentoVacinaOrphanCheck + " in its movimentoVacina field has a non-nullable vacina field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
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
