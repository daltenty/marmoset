package edu.umd.review.gwt.view;

import com.google.gwt.user.client.ui.HasValue;
import com.google.gwt.user.client.ui.IsWidget;

import edu.umd.review.gwt.presenter.IsPresenter;
import edu.umd.review.gwt.rpc.dto.NumericEvaluationDto;
import edu.umd.review.gwt.rpc.dto.NumericRubricDto;
import edu.umd.review.gwt.widget.RubricEvaluationControl;

public interface NumericRubricEvaluationView extends IsWidget, HasValue<String> {

  public interface Presenter extends IsPresenter, RubricEvaluationControl.Handler {}
  void setPresenter(Presenter presenter);

  void showEvaluation(NumericRubricDto rubric, NumericEvaluationDto evaluation);

  void setEditing(boolean editing);

  String getExplanation();
}
