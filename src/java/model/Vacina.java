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
@Table(name = "vacina")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Vacina.findAll", query = "SELECT v FROM Vacina v"),
    @NamedQuery(name = "Vacina.findByCodigo", query = "SELECT v FROM Vacina v WHERE v.codigo = :codigo"),
    @NamedQuery(name = "Vacina.findByDescricao", query = "SELECT v FROM Vacina v WHERE v.descricao = :descricao"),
    @NamedQuery(name = "Vacina.findByQtdeDose", query = "SELECT v FROM Vacina v WHERE v.qtdeDose = :qtdeDose")})
public class Vacina implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "codigo")
    private Integer codigo;
    @Size(max = 20)
    @Column(name = "descricao")
    private String descricao;
    @Column(name = "qtde_dose")
    private Integer qtdeDose;
    @OneToMany(mappedBy = "codigoVacina", fetch = FetchType.EAGER)
    private List<Lote> loteList;
    @OneToMany(mappedBy = "codigoVacina", fetch = FetchType.EAGER)
    private List<MovimentoVacina> movimentoVacinaList;

    public Vacina() {
    }

    public Vacina(Integer codigo) {
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

    public Integer getQtdeDose() {
        return qtdeDose;
    }

    public void setQtdeDose(Integer qtdeDose) {
        this.qtdeDose = qtdeDose;
    }

    @XmlTransient
    public List<Lote> getLoteList() {
        return loteList;
    }

    public void setLoteList(List<Lote> loteList) {
        this.loteList = loteList;
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
        if (!(object instanceof Vacina)) {
            return false;
        }
        Vacina other = (Vacina) object;
        if ((this.codigo == null && other.codigo != null) || (this.codigo != null && !this.codigo.equals(other.codigo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Vacina[ codigo=" + codigo + " ]";
    }
    
}
