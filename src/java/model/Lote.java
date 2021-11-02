/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Pedro
 */
@Entity
@Table(name = "lote")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Lote.findAll", query = "SELECT l FROM Lote l"),
    @NamedQuery(name = "Lote.findByCodigo", query = "SELECT l FROM Lote l WHERE l.codigo = :codigo"),
    @NamedQuery(name = "Lote.findByDescricao", query = "SELECT l FROM Lote l WHERE l.descricao = :descricao"),
    @NamedQuery(name = "Lote.findByQtdeUnidade", query = "SELECT l FROM Lote l WHERE l.qtdeUnidade = :qtdeUnidade"),
    @NamedQuery(name = "Lote.findByDoseDisponivel", query = "SELECT l FROM Lote l WHERE l.doseDisponivel = :doseDisponivel")})
public class Lote implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "codigo")
    private Integer codigo;
    @Size(max = 10)
    @Column(name = "descricao")
    private String descricao;
    @Column(name = "qtde_unidade")
    private Integer qtdeUnidade;
    @Column(name = "dose_disponivel")
    private Integer doseDisponivel;
    @OneToMany(mappedBy = "codigoLote", fetch = FetchType.EAGER)
    private List<Vacinacao> vacinacaoList;
    @JoinColumn(name = "codigo_vacina", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private Vacina codigoVacina;
    @OneToMany(mappedBy = "codigoLote", fetch = FetchType.EAGER)
    private List<MovimentoVacina> movimentoVacinaList;

    public Lote() {
    }

    public Lote(Integer codigo) {
        this.codigo = codigo;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Integer getQtdeUnidade() {
        return qtdeUnidade;
    }

    public void setQtdeUnidade(Integer qtdeUnidade) {
        this.qtdeUnidade = qtdeUnidade;
    }

    public Integer getDoseDisponivel() {
        return doseDisponivel;
    }

    public void setDoseDisponivel(Integer doseDisponivel) {
        this.doseDisponivel = doseDisponivel;
    }

    @XmlTransient
    public List<Vacinacao> getVacinacaoList() {
        return vacinacaoList;
    }

    public void setVacinacaoList(List<Vacinacao> vacinacaoList) {
        this.vacinacaoList = vacinacaoList;
    }

    public Vacina getCodigoVacina() {
        return codigoVacina;
    }

    public void setCodigoVacina(Vacina codigoVacina) {
        this.codigoVacina = codigoVacina;
    }

    @XmlTransient
    public List<MovimentoVacina> getMovimentoVacinaList() {
        return movimentoVacinaList;
    }

    public void setMovimentoVacinaList(List<MovimentoVacina> movimentoVacinaList) {
        this.movimentoVacinaList = movimentoVacinaList;
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
        if (!(object instanceof Lote)) {
            return false;
        }
        Lote other = (Lote) object;
        if ((this.codigo == null && other.codigo != null) || (this.codigo != null && !this.codigo.equals(other.codigo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Lote[ codigo=" + codigo + " ]";
    }
    
}
