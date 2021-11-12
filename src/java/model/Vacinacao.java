/*
VACINAÇÃO ======================================================================
Esta classe representa o processo de vacinação e sua implicação ao estoque. De
fato, quando uma pessoa se vacina, o estoque reduz. Essa dose que foi gasta na 
vacinação tem seu lote de proveniência informado. Vacinacação não existe na 
documentação original. Foi criada para facilitar e tornar mais coerente o código.
Seu SQL é:

CREATE TABLE vacinacao(
	codigo SERIAL PRIMARY KEY,
	codigo_usuario INT REFERENCES usuario (codigo),
	codigo_agenda INT REFERENCES agenda (codigo), //Este atributo vincula a vacinação ao agendamento que o usuário realizou.
	codigo_lote INT REFERENCES lote (codigo),
        codigo_usuario_apl INT REFERENCES usuario_apl (codigo),
        data_aplicacao timestamp
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
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Pedro
 */
@Entity
@Table(name = "vacinacao")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Vacinacao.findAll", query = "SELECT v FROM Vacinacao v"),
    @NamedQuery(name = "Vacinacao.findByCodigo", query = "SELECT v FROM Vacinacao v WHERE v.codigo = :codigo"),
    @NamedQuery(name = "Vacinacao.findByDataAplicacao", query = "SELECT v FROM Vacinacao v WHERE v.dataAplicacao = :dataAplicacao")})
public class Vacinacao implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "codigo")
    private Integer codigo;
    @Column(name = "data_aplicacao")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dataAplicacao;
    @JoinColumn(name = "codigo_agenda", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private Agenda codigoAgenda;
    @JoinColumn(name = "codigo_lote", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private Lote codigoLote;
    @JoinColumn(name = "codigo_usuario", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private Usuario codigoUsuario;
    @JoinColumn(name = "codigo_usuario_apl", referencedColumnName = "codigo")
    @ManyToOne(fetch = FetchType.EAGER)
    private UsuarioApl codigoUsuarioApl;

    public Vacinacao() {
    }

    public Vacinacao(Integer codigo) {
        this.codigo = codigo;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public Date getDataAplicacao() {
        return dataAplicacao;
    }

    public void setDataAplicacao(Date dataAplicacao) {
        this.dataAplicacao = dataAplicacao;
    }

    public Agenda getCodigoAgenda() {
        return codigoAgenda;
    }

    public void setCodigoAgenda(Agenda codigoAgenda) {
        this.codigoAgenda = codigoAgenda;
    }

    public Lote getCodigoLote() {
        return codigoLote;
    }

    public void setCodigoLote(Lote codigoLote) {
        this.codigoLote = codigoLote;
    }

    public Usuario getCodigoUsuario() {
        return codigoUsuario;
    }

    public void setCodigoUsuario(Usuario codigoUsuario) {
        this.codigoUsuario = codigoUsuario;
    }

    public UsuarioApl getCodigoUsuarioApl() {
        return codigoUsuarioApl;
    }

    public void setCodigoUsuarioApl(UsuarioApl codigoUsuarioApl) {
        this.codigoUsuarioApl = codigoUsuarioApl;
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
        if (!(object instanceof Vacinacao)) {
            return false;
        }
        Vacinacao other = (Vacinacao) object;
        if ((this.codigo == null && other.codigo != null) || (this.codigo != null && !this.codigo.equals(other.codigo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Vacinacao[ codigo=" + codigo + " ]";
    }
    
}
