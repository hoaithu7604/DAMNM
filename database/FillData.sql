DELETE FROM OrderHistory
DELETE FROM Employee
DELETE FROM Roles
DELETE FROM Orders
DELETE FROM Customers
DELETE FROM dbo.WorkflowScheme
DELETE FROM [dbo].[WorkflowProcessInstance]

Begin TRANSACTION
	INSERT dbo.Roles(Id, Name) VALUES ('69cb579b-0866-4585-aca8-efe9ef0ce2be','Manager')
	INSERT dbo.Roles(Id, Name) VALUES ('de2e905a-524f-453d-852d-d9b7b7551cb6','DeliveryUnit')
	/* thu 123 Manager */
	INSERT dbo.Employee(Id, Name, RoleId) VALUES ('8d378ebe-0666-46b3-b7ab-1a52480fd12a', N'Thu Nguyen','69cb579b-0866-4585-aca8-efe9ef0ce2be')
	INSERT dbo.Accounts(Id, Username, Password, EmployeeId) VALUES ('f6e34bdf-b769-42dd-a2be-fee67faf9045','thu','123','8d378ebe-0666-46b3-b7ab-1a52480fd12a')
	/* uht 123 Delivery Unit */
	INSERT dbo.Employee(Id, Name, RoleId) VALUES ('b415fbf2-e403-4da1-9967-63ee4ac40efa', N'Thu Nguyen','de2e905a-524f-453d-852d-d9b7b7551cb6')
	INSERT dbo.Accounts(Id, Username, Password, EmployeeId) VALUES ('02a915ac-66df-4d48-9171-b1f59ed34e5c','uht','123','b415fbf2-e403-4da1-9967-63ee4ac40efa')

	INSERT dbo.Customers(Id, Name) VALUES ('e0fca1e6-b6ea-44b1-af68-8e63e125a6bf', N'Thu Nguyen')

	INSERT dbo.Orders(Id, State, StateName, OwnerId) VALUES ('44c89831-2409-464d-b28c-87c5ee17fdaa', N'ManagerApproving',N'Manager approving', 'e0fca1e6-b6ea-44b1-af68-8e63e125a6bf')

	EXEC(N'INSERT dbo.WorkflowScheme(Code, Scheme) VALUES (N''SimpleWF'', N''
<Process Name="SimpleWF" CanBeInlined="false">
  <Designer />
  <Actors>
    <Actor Name="Manager" Rule="IsManager" Value="" />
    <Actor Name="DeliveryUnit" Rule="IsDeliveryUnit" Value="" />
    <Actor Name="Customer" Rule="CheckRole" Value="Customer" />
  </Actors>
  <Commands>
    <Command Name="Approve" />
    <Command Name="PassToDelivery" />
    <Command Name="Deliver" />
    <Command Name="Finish" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="ManagerApproving" State="ManagerApproving" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateOrderHistory" />
      </Implementation>
      <Designer X="70" Y="150" />
    </Activity>
    <Activity Name="WaitingForDelivery" State="WaitingForDelivery" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateOrderHistory" />
        <ActionRef Order="2" NameRef="UpdateStock" />
      </Implementation>
      <Designer X="447" Y="147.00000000000003" />
    </Activity>
    <Activity Name="ReadyForDelivery" State="ReadyForDelivery" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateOrderHistory" />
      </Implementation>
      <Designer X="806.9999999999999" Y="147" />
    </Activity>
    <Activity Name="OrderDelivering" State="OrderDelivering" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateOrderHistory" />
      </Implementation>
      <Designer X="816.9999999999999" Y="287" />
    </Activity>
    <Activity Name="OrderFinished" State="OrderFinished" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateOrderHistory" />
      </Implementation>
      <Designer X="806.9999999999999" Y="427" />
    </Activity>
    <Activity Name="OrderCanceled" State="OrderCanceled" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateOrderHistory" />
        <ActionRef Order="2" NameRef="UpdateStock" />
      </Implementation>
      <Designer X="260" Y="440" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="ManagerApproving_WaitingForDelivery_1" To="WaitingForDelivery" From="ManagerApproving" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Manager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Action" NameRef="IsApprovable" ConditionInversion="false" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="WaitingForDelivery_ReadyForDelivery_1" To="ReadyForDelivery" From="WaitingForDelivery" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Manager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="PassToDelivery" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" NameRef="IsApprovable" ConditionInversion="false" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="ReadyForDelivery_OrderDelivering_1" To="OrderDelivering" From="ReadyForDelivery" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="DeliveryUnit" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Deliver" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="OrderDelivering_OrderFinished_1" To="OrderFinished" From="OrderDelivering" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="DeliveryUnit" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Finish" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="ManagerApproving_OrderCanceled_1" To="OrderCanceled" From="ManagerApproving" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Manager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="WaitingForDelivery_OrderCanceled_1" To="OrderCanceled" From="WaitingForDelivery" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Manager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <CodeActions>
    <CodeAction Name="WriteOrderHistory" Type="Action" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[return;]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;System.Collections;System.Collections.Generic;]]></Usings>
    </CodeAction>
    <CodeAction Name="UpdateOrderHistory" Type="Action" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[if (string.IsNullOrEmpty(processInstance.CurrentCommand))
    return;
    
var currentstate = WorkflowInit.Runtime.GetLocalizedStateName(processInstance.ProcessId, processInstance.CurrentState);
if(currentstate == null)
{
   currentstate = processInstance.CurrentActivityName;
}
var nextState = WorkflowInit.Runtime.GetLocalizedStateName(processInstance.ProcessId, processInstance.ExecutedActivityState);
if(nextState == null)
{
    nextState = processInstance.ExecutedActivity.Name;
}
var command = WorkflowInit.Runtime.GetLocalizedCommandName(processInstance.ProcessId, processInstance.CurrentCommand);

if(!string.IsNullOrEmpty(processInstance.ExecutedTimer))
{
    command = string.Format("Timer: {0}",processInstance.ExecutedTimer);
}

Guid? employeeId = null;

if (!string.IsNullOrWhiteSpace(processInstance.IdentityId)) employeeId = new Guid(processInstance.IdentityId);

var repository = new OrderRepository();

repository.UpdateOrderHistory(processInstance.ProcessId, currentstate, nextState, command, employeeId);]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;WorkflowEngine;System.Collections;System.Collections.Generic;]]></Usings>
    </CodeAction>
    <CodeAction Name="IsManager" Type="RuleCheck" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[var repository = new EmployeeRepository();
return repository.CheckRole(identityId,"Manager");]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;WorkflowEngine;System.Collections;System.Collections.Generic;]]></Usings>
    </CodeAction>
    <CodeAction Name="IsApprovable" Type="Condition" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[return true;]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;System.Collections;System.Collections.Generic;]]></Usings>
    </CodeAction>
    <CodeAction Name="IsDeliveryUnit" Type="RuleCheck" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[var repository = new EmployeeRepository();
return repository.CheckRole(identityId,"DeliveryUnit");]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;System.Collections;System.Collections.Generic;WorkflowEngine;]]></Usings>
    </CodeAction>
    <CodeAction Name="CheckRole" Type="RuleCheck" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[var repository = new EmployeeRepository();
return repository.CheckRole(identityId,parameter);]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;System.Collections;System.Collections.Generic;WorkflowEngine;]]></Usings>
    </CodeAction>
    <CodeAction Name="UpdateStock" Type="Action" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[return;]]></ActionCode>
      <Usings><![CDATA[System.Linq;System;OptimaJet.Workflow;OptimaJet.Workflow.Core.Model;System.Threading.Tasks;System.Threading;System.Collections;System.Collections.Generic;]]></Usings>
    </CodeAction>
  </CodeActions>
  <Localization>
    <Localize Type="Command" IsDefault="True" Culture="en-US" ObjectName="Approve" Value="Approve" />
    <Localize Type="Command" IsDefault="True" Culture="en-US" ObjectName="PassToDelivery" Value="Pass to delivery" />
    <Localize Type="Command" IsDefault="True" Culture="en-US" ObjectName="Deliver" Value="Deliver" />
    <Localize Type="Command" IsDefault="True" Culture="en-US" ObjectName="Finish" Value="Finish" />
    <Localize Type="Command" IsDefault="True" Culture="en-US" ObjectName="Cancel" Value="Cancel" />
    <Localize Type="State" IsDefault="True" Culture="en-US" ObjectName="ManagerApproving" Value="Manager approving" />
    <Localize Type="State" IsDefault="True" Culture="en-US" ObjectName="WaitingForDelivery" Value="Waiting for delivery" />
    <Localize Type="State" IsDefault="True" Culture="en-US" ObjectName="ReadyForDelivery" Value="Ready for delivery" />
    <Localize Type="State" IsDefault="True" Culture="en-US" ObjectName="OrderFinished" Value="Finished" />
    <Localize Type="State" IsDefault="True" Culture="en-US" ObjectName="OrderCanceled" Value="Canceled" />
    <Localize Type="State" IsDefault="True" Culture="en-US" ObjectName="OrderDelivering" Value="Order delivering" />
  </Localization>
</Process>
'')')

Commit TRANSACTION