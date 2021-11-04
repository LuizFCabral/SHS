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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            
        </script>
    </head>
    <body>
        <%
            request.setCharacterEncoding("UTF-8");
            Usuario u = new Usuario();
            Banco bb = new Banco();
            DAOJPA daoJ = new DAOJPA();
            SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
            SimpleDateFormat tF = new SimpleDateFormat("yyyy-MM-dd HH:mm"); //Formatador geral
            SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de hora
            MovimentoVacinaJpaController dao = new MovimentoVacinaJpaController(Banco.conexao);
            Timestamp hoje = new Timestamp(System.currentTimeMillis());
            UsuarioApl apl;
            try
            {
                if(session.getAttribute("login") == null || session.getAttribute("classe") != UsuarioApl.class)
                    throw new Exception("Log-in não feito ou credenciais insuficientes");
                apl = (UsuarioApl)session.getAttribute("login");
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
                        <h1>Agendamento vigente</h1>
                        <%
                            boolean isVigente = false;
                            if(u.getAgendaList().isEmpty())
                            {
                                %><h4>Não há agendamento vigente.</h4><%
                            }
                            else
                            {
                                List<Agenda> lista = u.getAgendaList();
                                for(int i = 0; i < lista.size(); i++)
                                {
                                    if(lista.get(i).getVacinacaoList().isEmpty())
                                    {
                                        Agenda vigente = lista.get(i);
                                        isVigente = true;
                                        %>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Código</th>
                                                    <th>Data de modificação</th>
                                                    <th>Hora de modificação</th>
                                                    <th>Código de usuário</th>
                                                    <th>Data marcada</th>
                                                    <th>Hora marcada</th>
                                                    <th>Número da dose</th>
                                                    <th>Situação</th>
                                                </tr>
                                                <tr>
                                                    <td><%=vigente.getCodigo()%></td>
                                                    <td><%=dF.format(vigente.getDataAgendamento())%></td>
                                                    <td><%=hF.format(vigente.getDataAgendamento())%></td>
                                                    <td><%=vigente.getCodigoUsuario().getCodigo()%></td>
                                                    <td><%=dF.format(vigente.getDataVacinacao())%></td>
                                                    <td><%=hF.format(vigente.getDataVacinacao())%></td>
                                                    <td><%=vigente.getDoseNumero()%></td>
                                                    <%
                                                        if(hoje.getDate() == vigente.getDataVacinacao().getDate())
                                                        {
                                                            %><td>dia certo</td><%
                                                        }
                                                        else
                                                        {
                                                            if(hoje.before(vigente.getDataVacinacao()))
                                                            {
                                                                %><td>adiantado</td><%
                                                            }
                                                            else
                                                            {
                                                                %><td>atrasado</td><%
                                                            }
                                                        }
                                                    %>
                                                </tr>
                                            </thead>
                                        </table>
                            <%
                                        break;
                                    }
                                }
                                if(!isVigente)
                                {
                                    %><h4>Não há agendamento vigente.</h4><%
                                }
                            }
                        %>
                        <h1>Dados da vacina</h1>
                        Descrição: <input type="text" name="txtDescr"/><br/>
                        Lote utilizado: <input type="text" name="txtLote"/><br/>
                        <br/><br/>
                        <%
                            if(!isVigente)
                                {
                                    %><h4>Criar agendamento agora e confirmar:</h4>
                                    Num. da dose: <input type="text" name="txtNumDose"/><br/><br/><%
                                }
                        %>
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
                        boolean novo = false;
                        List<Agenda> lista = u.getAgendaList();
                        if(lista == null || lista.isEmpty())
                            novo = true;
                        Agenda a = new Agenda();
                        int i;
                        for(i = 0; i<lista.size(); i++)
                        {
                            a = lista.get(i);
                            if(a.getVacinacaoList().isEmpty())
                            {
                                novo = false;
                                break;
                            }
                        }
                        if(novo)
                        {
                            a = new Agenda();
                            a.setCodigoUsuario(u);
                            a.setDataAgendamento(hoje);
                            a.setDataVacinacao(hoje);
                            a.setDoseNumero(Integer.parseInt(request.getParameter("txtNumDose")));
                            AgendaJpaController daoA = new AgendaJpaController(Banco.conexao);
                            daoA.create(a);
                        }
                        vac.setCodigoAgenda(a);
                        vac.setDataAplicacao(hoje);
                        vac.setCodigoUsuarioApl(apl);
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
