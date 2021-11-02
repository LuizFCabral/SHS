<%-- 
    Document   : atualizarVacina
    Created on : 09/10/2021, 17:14:15
    Author     : Pedro
--%>

<%@page import="controller.*"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Confirmar aplicação de vacina</title>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            Usuario u = new Usuario();
            Banco bb = new Banco();
            DAOJPA daoJ = new DAOJPA();
            SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
            SimpleDateFormat tF = new SimpleDateFormat("yyyy-MM-dd HH:mm"); //Formatador geral
            MovimentoVacinaJpaController dao = new MovimentoVacinaJpaController(Banco.conexao);
            Timestamp hoje;
            try
            {
                if(request.getParameter("b1") == null)
                {
        %>
        <form action="atualizarVacina.jsp">
            CPF: <input type="text" name="txtCPF"/>
            <input type="submit" name="b1" value="Procurar"/>
        </form>
        <%
                }
                else
                {
                    if(request.getParameter("b1").equalsIgnoreCase("Procurar"))
                    {
                        u = (Usuario) daoJ.searchCPF(bb, request.getParameter("txtCPF"), u.getClass());
        %>
                    <form action="atualizarVacina.jsp">
                        <h1>Dados da pessoa</h1>
                        CPF: <input type="text" name="txtCPF" value="<%=u.getCpf()%>" readonly/> <br/>
                        Código: <input type="text" name="txtCodigo" value="<%=u.getCodigo()%>" readonly/> <br/>
                        Nome: <input type="text" name="txtNome" value="<%=u.getNome()%>" readonly/> <br/>
                        Data de nascimento: <input type="text" name="txtDataNasc" value="<%=dF.format(u.getDataNascimento())%>" readonly/> <br/>
                        Cidade:<input type="text" name="txtCidade" value="<%=u.getCidade()%>" readonly/> <br/>
                        <h1>Dados da vacina</h1>
                        Descrição: <input type="text" name="txtDescr"/><br/>
                        Lote utilizado: <input type="text" name="txtLote"/><br/>
                        <br/><br/>
                        Seu CPF: <input type="text" name="txtEnfermeiro"/>
                        <br/><br/>
                        <input type="submit" name="b1" value="confirmar"/>
                    </form>
        
        <%
                    }

                    if(request.getParameter("b1").equalsIgnoreCase("confirmar"))
                    {
                        Vacina v = new Vacina();
                        UsuarioJpaController daoU = new UsuarioJpaController(Banco.conexao);
                        int cod = Integer.parseInt(request.getParameter("txtCodigo"));
                        u = daoU.findUsuario(cod); //pega o obj usuário 
                        String descr = request.getParameter("txtDescr");
                        v = daoJ.vacinaByDescr(bb, descr); //pega o obj vacina
                        MovimentoVacina mov = new MovimentoVacina();
                        mov.setTipoMovimento("S");
                        mov.setCodigoVacina(v);
                        mov.setQtdeDose(1);
                        hoje = new Timestamp(System.currentTimeMillis());
                        mov.setDataMovimento(hoje);
                        String lote = request.getParameter("txtLote");
                        daoJ = new DAOJPA();
                        Lote l = daoJ.loteByDescricao(bb, lote);
                        mov.setCodigoLote(l);
                        LoteJpaController daoL = new LoteJpaController(Banco.conexao);
                        l.setDoseDisponivel(l.getDoseDisponivel() - 1);
                        daoL.edit(l);
                        dao.create(mov);
                        Vacinacao vac = new Vacinacao();
                        vac.setCodigoLote(l);
                        vac.setCodigoUsuario(u);
                        List<Agenda> lista = u.getAgendaList();
                        Agenda a = new Agenda();
                        for(int i = 0; i<lista.size(); i++)
                        {
                            a = lista.get(i);
                            if(a.getVacinacaoList().isEmpty())
                            {
                                break;
                            }
                        }
                        vac.setCodigoAgenda(a);
                        vac.setDataAplicacao(hoje);
                        vac.setCodigoUsuarioApl((UsuarioApl) daoJ.searchCPF(bb, request.getParameter("txtEnfermeiro"), UsuarioApl.class));
                        VacinacaoJpaController daoVac = new VacinacaoJpaController(Banco.conexao);
                        daoVac.create(vac);
                        %>pronto!<%
                        Banco.conexao.close();
                    }
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>
<%
            }
        %>
    </body>
</html>
