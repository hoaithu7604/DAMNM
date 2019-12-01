using System;
using System.Xml.Linq;
using OptimaJet.Workflow.Core.Builder;
using OptimaJet.Workflow.Core.Bus;
using OptimaJet.Workflow.Core.Runtime;
using OptimaJet.Workflow.DbPersistence;
namespace WorkflowEngine
{
    public static class WorkflowInit
    {
        private static readonly Lazy<WorkflowRuntime> LazyRuntime = new Lazy<WorkflowRuntime>(InitWorkflowRuntime);

        public static WorkflowRuntime Runtime
        {
            get { return LazyRuntime.Value; }
        }

        private static WorkflowRuntime InitWorkflowRuntime()
        {
            var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var dbProvider = new MSSQLProvider(connectionString);

            var builder = new WorkflowBuilder<XElement>(
                dbProvider,
                new OptimaJet.Workflow.Core.Parser.XmlWorkflowParser(),
                dbProvider
            ).WithDefaultCache();

            var runtime = new WorkflowRuntime()
                .WithBuilder(builder)
                .WithPersistenceProvider(dbProvider)
                .WithBus(new NullBus())
                .EnableCodeActions()
                .SwitchAutoUpdateSchemeBeforeGetAvailableCommandsOn();
            runtime.ProcessActivityChanged += (sender, args) => { };
            runtime.ProcessStatusChanged += (sender, args) => { };
            runtime.Start();

            return runtime;
        }
    }
}
