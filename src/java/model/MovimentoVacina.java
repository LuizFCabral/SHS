/*
CLASSE MOVIMENTO VACINA ====================================================================
Esta classe abstrai os movimentos que ocorrem no estoque com a entrada e saída de 
vacinas. Uma coisa importante a notar é que: 1. movimentos de entrada significam 
exclusivamente entrada de lotes inteiros no estoque, ou seja, não se pode adicionar 
uma dose por vez no sistema e 2. movimentos de saída não têm a ver com o desconto 
de doses por conta da vacinação de alguém, mas com, por exemplo, perda de doses 
por vencimento, quebra de vidro em que estão etc. A situação do desconto
de doses por vacinação tem classe própria. O SQL do movimento vacina é:

create table movimento_vacina(
    codigo serial primary key,
    codigo_vacina int REFERENCES vacina (codigo),
    data_movimento timestamp,
    tipo_movimento varchar(1),
    qtde_dose int,
    codigo_lote int references lote (codigo) 
);
 */
package model;

import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Pedro
 */
@Entity
@Table(name = "movimento_vacina")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "MovimentoVacina.findAll", query = "SELECT m FROM MovimentoVacina m"),
    @NamedQuery(name = "MovimentoVacina.findByCodigo", query = "SELECT m FROM MovimentoVacina m WHERE m.codigo = :codigo"),
    @NamedQuery(name = "MovimentoVacina.findByDataMovimento", query = "SELECT m FROM MovimentoVacina m WHERE m.dataMovimento = :dataMovimento"),
    @NamedQuery(name = "MovimentoVacina.findByTipoMovimento", query = "SELECT m FROM MovimentoVacina m WHERE m.tipoMovimento = :tipoMovimento"),
    @NamedQuery(name = "MovimentoVacina.findByQtdeDose", query = "SELECT m FROM MovimentoVacina m WHERE m.qtdeDose = :qtdeDose")})
public class MovimentoVacina implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "codigo")
    private Integer codigo;
    @Column(name = "data_movimento")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dataMovimento;
    @Size(max = 1)
    @Column(name = "tipo_movimento")
    private String tipoMovimento;
    @Column(name = "qtde_dose")
    private Integer qtdeDose;
    @JoinColumn(name = "codigo_lote", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private Lote codigoLote;
    @JoinColumn(name = "codigo_vacina", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private Vacina codigoVacina;

    public MovimentoVacina() {
    }

    public MovimentoVacina(Integer codigo) {
        this.codigo = codigo;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public Date getDataMovimento() {
        return dataMovimento;
    }

    public void setDataMovimento(Date dataMovimento) {
        this.dataMovimento = dataMovimento;
    }

    public String getTipoMovimento() {
        return tipoMovimento;
    }

    public void setTipoMovimento(String tipoMovimento) {
        this.tipoMovimento = tipoMovimento;
    }

    public Integer getQtdeDose() {
        return qtdeDose;
    }

    public void setQtdeDose(Integer qtdeDose) {
        this.qtdeDose = qtdeDose;
    }

    public Lote getCodigoLote() {
        return codigoLote;
    }

    public void setCodigoLote(Lote codigoLote) {
        this.codigoLote = codigoLote;
    }

    public Vacina getCodigoVacina() {
        return codigoVacina;
    }

    public void setCodigoVacina(Vacina codigoVacina) {
        this.codigoVacina = codigoVacina;
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
        if (!(object instanceof MovimentoVacina)) {
            return false;
        }
        MovimentoVacina other = (MovimentoVacina) object;
        if ((this.codigo == null && other.codigo != null) || (this.codigo != null && !this.codigo.equals(other.codigo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.MovimentoVacina[ codigo=" + codigo + " ]";
    }
    
    public String completarTipo() throws Exception
    {
        String t = tipoMovimento;
        try{
            if(!t.equals("S") && !t.equals("E"))
                throw new Exception("Tipo não válido!");
            if(t.equals("S"))
                t = "Saída";
            if(t.equals("E"))
                t = "Entrada";
        }
        catch(Exception ex)
        {
            throw new Exception("Erro na função completarTipo: " + ex.getMessage());
        }
        return t;
    }
    
}
