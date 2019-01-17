FROM snipe/snipe-it
LABEL com.trilogy.company="trilogy" \
      com.trilogy.maintainer.email="jaime.bravo@aurea.com" \
      com.trilogy.maintainer.skype="jabhcl" \
      com.trilogy.product="snipe-it" \
      com.trilogy.service="devspace" \
      com.trilogy.stage="build" \
      com.trilogy.team="Eng.DevSpacesImport" \
      description="This file generates a docker image containing Snipe-IT Application"
ADD assets/install /assets
WORKDIR /assets
RUN chmod +x install.sh && ./install.sh
ADD assets/setup /assets
WORKDIR /assets
RUN chmod +x setup.sh && ./setup.sh
WORKDIR /
RUN rm -rf /assets
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
