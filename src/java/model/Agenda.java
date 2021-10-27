package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author vinif
 */
@Entity
@Table(name = "agenda")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Agenda.findAll", query = "SELECT a FROM Agenda a"),
    @NamedQuery(name = "Agenda.findByCodigo", query = "SELECT a FROM Agenda a WHERE a.codigo = :codigo"),
    @NamedQuery(name = "Agenda.findByCodigoUsuario", query = "SELECT a FROM Agenda a INNER JOIN a.usuario u WHERE u.codigo = :codigo"),
    @NamedQuery(name = "Agenda.findByDataAgendamento", query = "SELECT a FROM Agenda a WHERE a.dataAgendamento = :dataAgendamento"),
    @NamedQuery(name = "Agenda.findByDataVacinacao", query = "SELECT a FROM Agenda a WHERE a.dataVacinacao = :dataVacinacao"),
    @NamedQuery(name = "Agenda.findByDoseNumero", query = "SELECT a FROM Agenda a WHERE a.doseNumero = :doseNumero")})
public class Agenda implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "codigo")
    private Integer codigo;
    @Column(name = "data_agendamento")
    @Temporal(TemporalType.DATE)
    private Date dataAgendamento;
    @Column(name = "data_vacinacao")
    @Temporal(TemporalType.DATE)
    private Date dataVacinacao;
    @Column(name = "dose_numero")
    private Integer doseNumero;
    @OneToMany(mappedBy = "codigoAgenda")
    private List<Vacinacao> vacinacaoList;
    @JoinColumn(name = "codigo_usuario", referencedColumnName = "codigo")
    @ManyToOne
    private Usuario codigoUsuario;

    public Agenda() {
    }

    public Agenda(Integer codigo) {
        this.codigo = codigo;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public Date getDataAgendamento() {
        return dataAgendamento;
    }

    public void setDataAgendamento(Date dataAgendamento) {
        this.dataAgendamento = dataAgendamento;
    }

    public Date getDataVacinacao() {
        return dataVacinacao;
    }

    public void setDataVacinacao(Date dataVacinacao) {
        this.dataVacinacao = dataVacinacao;
    }

    public Integer getDoseNumero() {
        return doseNumero;
    }

    public void setDoseNumero(Integer doseNumero) {
        this.doseNumero = doseNumero;
    }

    @XmlTransient
    public List<Vacinacao> getVacinacaoList() {
        return vacinacaoList;
    }

    public void setVacinacaoList(List<Vacinacao> vacinacaoList) {
        this.vacinacaoList = vacinacaoList;
    }

    public Usuario getCodigoUsuario() {
        return codigoUsuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (codigo != null ? codigo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Agenda)) {
            return false;
        }
        Agenda other = (Agenda) object;
        if ((this.codigo == null && other.codigo != null) || (this.codigo != null && !this.codigo.equals(other.codigo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Agenda[ codigo=" + codigo + " ]";
    }
    
}
