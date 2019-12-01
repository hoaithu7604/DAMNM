using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DAMNM.Model
{
    public class OrderModel
    {
        public Guid Id { get; set; }
        public string State { get; set; }
        public Guid OwnerId { get; set; }
        public string OwnerName { get; set; }

        public OrderCommandModel[] Commands { get; set; }
    }
    public class OrderCommandModel
    {
        public string key { get; set; }
        public string value { get; set; }
        public OptimaJet.Workflow.Core.Model.TransitionClassifier Classifier { get; set; }
    }

}