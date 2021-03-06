package edu.umd.review.gwt.presenter;

import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;

import net.customware.gwt.dispatch.client.DispatchAsync;

import com.allen_sauer.gwt.dnd.client.PickupDragController;
import com.allen_sauer.gwt.dnd.client.drop.DropController;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import com.google.gwt.user.client.rpc.AsyncCallback;

import edu.umd.review.common.action.ListGeneralCommentsAction;
import edu.umd.review.common.action.ListGeneralCommentsAction.Response;
import edu.umd.review.common.action.NewThreadAction;
import edu.umd.review.gwt.GwtUtils;
import edu.umd.review.gwt.PresenterFactory;
import edu.umd.review.gwt.rpc.dto.RubricDto;
import edu.umd.review.gwt.rpc.dto.ThreadDto;
import edu.umd.review.gwt.view.GeneralCommentsView;
import edu.umd.review.gwt.view.ThreadView;

public class GeneralCommentsPresenter implements GeneralCommentsView.Presenter {
  private final GeneralCommentsView view;
  private final DispatchAsync dispatch;
  private final PresenterFactory presenterFactory;
  private final List<IsPresenter> startedPresenters = Lists.newArrayList();
  private final PickupDragController dragController;

  @Inject
  public GeneralCommentsPresenter(GeneralCommentsView view, DispatchAsync dispatch, PresenterFactory presenterFactory,
      PickupDragController dragController) {
    this.view = Preconditions.checkNotNull(view);
    this.dispatch = Preconditions.checkNotNull(dispatch);
    this.presenterFactory = Preconditions.checkNotNull(presenterFactory);
    this.dragController = Preconditions.checkNotNull(dragController);
  }
  
  @Override
  public void start() {
    this.view.setPresenter(this);
    view.clear();
    dispatch.execute(new ListGeneralCommentsAction(), new AsyncCallback<ListGeneralCommentsAction.Response>() {
      @Override
      public void onFailure(Throwable caught) {
        GwtUtils.wrapAndThrow(caught);
      }

      @Override
      public void onSuccess(Response result) {
        for (ThreadDto thread : result.getThreads()) {
          showThread(thread);
        }
      }
    });
  }

  private void showThread(ThreadDto thread) {
    ThreadView threadView = view.newThreadView();
    ThreadView.Presenter threadPresenter = presenterFactory.makeThreadPresenter(threadView, thread);
    threadPresenter.start();
    startedPresenters.add(threadPresenter);
  }

  @Override
  public void finish() {
    this.view.setPresenter(null);
    view.clear();
    for (Iterator<IsPresenter> iter = startedPresenters.iterator(); iter.hasNext();) {
      IsPresenter presenter = iter.next();
      presenter.finish();
      iter.remove();
    }
  }

  @Override
  public void createNewThread() {
    dispatch.execute(new NewThreadAction(), new AsyncCallback<ThreadDto>() {
      @Override
      public void onFailure(Throwable caught) {
        GwtUtils.wrapAndThrow(caught);
      }

      @Override
      public void onSuccess(ThreadDto thread) {
        showThread(thread);
      }
    });
  }
  
  @Override
  public void newThreadWithRubric(RubricDto rubric) {
    dispatch.execute(new NewThreadAction(null, 0, rubric), new AsyncCallback<ThreadDto>() {
      @Override
      public void onFailure(Throwable caught) {
        GwtUtils.wrapAndThrow(caught);
      }

      @Override
      public void onSuccess(ThreadDto result) {
        showThread(result);
      }
    });
  }
  
  @Override
  public void registerDropController(DropController controller) {
    dragController.registerDropController(controller);
  }
  
  @Override
  public void unregisterDropController(DropController controller) {
    dragController.unregisterDropController(controller);
  }
}
