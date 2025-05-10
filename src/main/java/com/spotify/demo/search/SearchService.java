package com.spotify.demo.search;

import org.springframework.stereotype.Service;
import com.spotify.demo.search.proto.QueryRequest;
import com.spotify.demo.search.proto.QueryResponse;
import com.spotify.demo.search.proto.SearchServiceGrpc.SearchServiceImplBase;
import io.grpc.stub.StreamObserver;

@Service
class SearchService extends SearchServiceImplBase {

  @Override
  public void query(QueryRequest req, StreamObserver<QueryResponse> responseObserver) {
    var reply = QueryResponse.newBuilder().build();
    responseObserver.onNext(reply);
    responseObserver.onCompleted();
  }

}
